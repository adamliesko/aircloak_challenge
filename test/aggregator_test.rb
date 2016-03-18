require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/aggregator', __FILE__)

class AggregatorTest < Minitest::Test
  def test_creates_empty_histogram_for_empty_set_of_purchases
    aggregator = Aggregator.new
    aggregator.add_purchases([])
    assert_equal({}, aggregator.aggregated_purchases)
  end

  def test_creates_histogram_aggregations_for_purchases
    set1 = Set.new([['type1', 12], ['type2', 13], ['type2', 13]])
    set2 = Set.new([['type2', 13], ['type2', 13]])

    aggregator = Aggregator.new
    aggregator.add_purchases(set1)

    assert_equal 1,  aggregator.aggregated_purchases[['type1', 12]]
    assert_equal 1,  aggregator.aggregated_purchases[['type2', 13]]

    aggregator.add_purchases(set2)

    assert_equal 1,  aggregator.aggregated_purchases[['type1', 12]]
    assert_equal 2,  aggregator.aggregated_purchases[['type2', 13]]
  end

  def test_initiliaze_method_creates_hash_with_0_as_default_values
    aggregator = Aggregator.new
    assert_equal 0, aggregator.aggregated_purchases[:abc]
  end
end
