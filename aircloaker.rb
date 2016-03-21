require 'clamp'
require File.expand_path('../lib/runner', __FILE__)

# Command line utility to ease parameter parsing and provide flexibale approach to run the processing
Clamp do
  parameter 'PATH', 'path to input directory with json records of user purchases', attribute_name: :input_dir
  option ['--type', '-t'], 'TYPE', 'desired type of purchase to aggregate', attribute_name: :type, default: 'airline'
  option ['--anon_fnc', '-f'], 'ANONYMIZATION_FNC', 'anonymization filter function in form of a Proc string (e.g. (_purchase_kind, count) { count > 5 }', attribute_name: :anon_fnc

  def execute
    res = Runner.run(input_dir, type, &parse_anonymization_function)
  rescue ArgumentError => err
    res = "[E] #{err.class}: #{err.message}.\nPlease check your input parameters. Use -h flag to display help."
  ensure
    puts(res) if res
  end

  def parse_anonymization_function
    anonymization_function = eval(anon_fnc) if anon_fnc
    anonymization_function ||= -> (_purchase_kind, count) { count > 5 }
  end
end
