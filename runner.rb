require './processor'

# Runner sets up Aggregator, Anonymizer (with anonymizing function) and Processor instances.
# Runs the processing in the path directory and filters purchases of a certain type

module Runner
  def self.run(path, type)
    aggregator = Aggregator.new
    anonymizer = init_anonymizer
    processor = Processor.new(aggregator, anonymizer, path)
    p processor.process_user_files(type)
  end

  def self.init_anonymizer
    anonymize_function = -> (_key, val) { val > 5 }
    Anonymizer.new(&anonymize_function)
  end
end

Runner.run('/Users/Adam/aircloak_challenge/data', 'airline')
