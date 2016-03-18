# Aircloak anonymization challenge

You are given a dataset containing a set of user ID's. Associated with
each user id is one or more purchases. __Your task__ is to calculate the following statistical
properties of the airline ticket purchase prices across all users, in a way that doesn't violate
the privacy of the individuals in the dataset:

- the `min` and `max` purchase price
- the `average` and `median` purchase price


## Installation instruction
Use of ruby 2.2 recommended (tested on 2.2.3 and 2.3.0). You can use rvm for installing Ruby.
Please, run the following to command in order to install and setup required libraries (for testing and cmd utility).

`bundle install`

## Usage

```
Usage:
    aircloaker.rb [OPTIONS] PATH

Parameters:
    PATH                          path to input directory with json records of user purchases

Options:
    --type, -t TYPE               desired type of purchase to aggregate (default: "airline")
    --anon_fnc, -f ANONYMIZATION FNC desired type of purchase to aggregate (default: "-> (_purchase_kind, count) { count > 5 }")
    -h, --help                    print help
```

### Example usage
User provides only the directory with JSON purchases. Default values for type and anonymization function are provided as described in the challenge.

```
ruby aircloaker.rb path/to/input/directory
```

User provides anonymization filtering function, desired type to filter and path to the directory with JSON purchases.

```
ruby aircloaker.rb  -t airline -f " -> (purchase_kind, count) {count > 5} " path/to/input/directory
```

### Output

`{:min=>150, :max=>150, :avg=>150.0, :median=>150.0}`

## Solution

I opted (or aimed) for easily extensible and universal solution. At first, I wanted to go probably too far and generalize to solution to the notion of records instead of purchases. The structure of inputs files could have been parsed from the input arguments, but it would make the code less readable and I wanted to avoid this pitfall.

Instead, I settled on a more stricter solution, but still very easily customizable one. For example, the required Anonymization step of removing tuples of count < 5, can be easily substituted with any Ruby Procedure. If one would like to filter out all results with count between 50 and 100, or even something totally different (e.g. filter records processed in odd second), user can supply a Proc as an argument to the command line tool `-f " -> (purchase_kind, count) {count > 50 && count < 100} "`. If no procedure is supplied, then the default (count > 5) is used. Second property, which makes the solution modifiable, is the option for providing certain type to filter the results on. If the type is not provided with the `-t` parameter `-t car`, airline is used as default.

My goals were to adhere to the best coding and development practices, mainly ensuring the single responsibility principle (to a healthy level). All code is tested with unit tests. I have also used stubbing for ensuring that the unit tests test the behaviour of the single class and not it's dependants. This was easily possible with the use of dependency injection pattern in the constructor of Processor. RunnerTest plays the role of a integration test.

Why did I choose Ruby for the implementation? It is my favorite language and when the actual efficiency or speed of
processing wasn't explicitly mentioned in the judging criteria, I didn't have any other reason to avoid it.
I have actually tried using a multi-threaded processing of user input files, but the overhead made it only slower on such a small number records. In production environment, with bigger dataset - I would definitely test, what performs better in regard to the source data. Generally, I favored readability over the code performance.

Thank you for providing me with this exciting coding challenge. I have actually enjoyed it and learned a new way to compute median value from histogram ( the technique is not used in the code because of the lower readibility).

## Ensuring anonymization

> When you work on the data of a particular user, you have to make decisions based on the data of that user in
> isolation of any data about other users. More concretely, this means that given users `A` and `B`,
> when you process the data of `B` after having processed the data of user `A`, you have no recollection of what
> user `A`'s data looked like, or what you reported about user `A`.

Code is processing only data of one user at a time. After processing data of certain user/s, code has no recollection of which data belongs to who.

### Why the difference from default (non-anonymized) processing?

I see two causes for the difference from natural min,max,avg,median stats from the dataset or from the results which where provided in the README.md by Aircloak.

#### Once per user restriction

The restriction for reported tuples of only one occurrence per user, as following:

> For example, the following three tuples are ok:
> ...

> whereas the following are not:
> ...

> They should instead be treated as a single occurrence of the tuple `(likes, green)`.

removes lot of actual data and skews the reported tuples.


#### Anonymization filtering function

Secondly, one of the requirements in the challenge was to filter out any records, which count is lower then 5. Because of this, majority of the airline purchases
are removed and dataset is reduced to a single record.
