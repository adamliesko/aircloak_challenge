require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/runner', __FILE__)

class RunnerTest < Minitest::Test
  def test_runnner_run_initializes_and_runs_the_processing
    anonymize_function = -> (_purchase_kind, count) { count > 5 }
    stats = Runner.run('/Users/Adam/aircloak_challenge/data', 'airline', &anonymize_function)
    assert_equal 150, stats[:min]
    assert_equal 150, stats[:max]
    assert_equal 150, stats[:avg]
    assert_equal 150, stats[:median]
  end
end
