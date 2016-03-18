require 'clamp'
require File.expand_path('../lib/runner', __FILE__)

# Command line utility to ease parameter parsing
class AircloakCommand < Clamp::Command
  parameter 'PATH', 'path to input directory with json records of user purchases', attribute_name: :input_dir
  option ['--type', '-t'], 'TYPE', 'desired type of purchase to aggregate', attribute_name: :type, default: 'airline'
  option ['--anon_fnc', '-f'], 'ANONYMIZATION FNC', 'desired type of purchase to aggregate', attribute_name: :anon_fnc, default: -> (_purchase_kind, count) { count > 5 } do
    eval(anon_fnc)
  end

  def execute
    res = Runner.run(input_dir, type, &anon_fnc)
    puts(res)
  end
end

AircloakCommand.run
