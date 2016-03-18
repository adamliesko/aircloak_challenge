require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/stats_utils', __FILE__)
require File.expand_path('../../lib/purchase', __FILE__)

class StatsUtilsTest < Minitest::Test
  def test_min_max_values
    assert_equal [nil, nil], StatsUtils.min_max_values([])
    assert_equal [10, 500], StatsUtils.min_max_values([[Purchase.new('airline', 10), 1], [Purchase.new('airline', 500), 2]])
  end

  def test_median
    assert_equal 1, StatsUtils.median([1, 1, 1, 4], 4)
    assert_equal 2, StatsUtils.median([1, 3], 2)
    assert_equal nil, StatsUtils.median([], 0)
  end

  def test_avg_and_median_computation
    sorted_purchases = [[Purchase.new('airline', 150), 10],
                        [Purchase.new('airline', 9000), 1],
                        [Purchase.new('airline', 10_000), 5]]
    assert_equal [3781.25, 150], StatsUtils.compute_avg_and_median(sorted_purchases, 16)
    sorted_purchases = [[Purchase.new('airline', 150), 1],
                        [Purchase.new('airline', 9000), 1]]
    assert_equal [4575.0, 4575.0], StatsUtils.compute_avg_and_median(sorted_purchases, 2)
  end
end
