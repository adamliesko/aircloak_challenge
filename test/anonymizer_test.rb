require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/anonymizer', __FILE__)
require File.expand_path('../../lib/purchase', __FILE__)

class AnonymizerTest < Minitest::Test
  def test_anonymization_and_computation_of_resulting_stats_with_over_5_anonymization
    filter_fnc_over_5 = -> (_, count) { count > 5 }
    anonymizer = Anonymizer.new(&filter_fnc_over_5)
    purchases = { Purchase.new('airline', 150) => 10, Purchase.new('airline', 10_000) => 5, Purchase.new('airline', 9000) => 1 }
    anonymized_purchases = anonymizer.anonymize_purchases(purchases)

    assert_equal({ Purchase.new('airline', 150) => 10 }, anonymized_purchases)

    stats = anonymizer.resulting_stats

    assert_equal 150, stats[:min]
    assert_equal 150, stats[:max]
    assert_equal 150, stats[:avg]
    assert_equal 150, stats[:median]
  end

  def test_anonymization_and_computation_of_resulting_stats_with_over_5_anonymization_and_bigger_input
    filter_fnc_over_5 = -> (_, count) { count > 5 }
    anonymizer = Anonymizer.new(&filter_fnc_over_5)
    purchases = { Purchase.new('airline', 150) => 10, Purchase.new('airline', 10_000) => 7, Purchase.new('airline', 9000) => 99 }
    anonymized_purchases = anonymizer.anonymize_purchases(purchases)

    assert_equal purchases, anonymized_purchases

    stats = anonymizer.resulting_stats

    assert_equal 150, stats[:min]
    assert_equal 10_000, stats[:max]
    assert_equal 8297.413793103447.round(2), stats[:avg].round(2)
    assert_equal 9000, stats[:median]
  end

  def test_anonymization_and_computation_of_resulting_stats_without_anonymization_filter
    filter_fnc_all = -> (_, _) { true }
    anonymizer = Anonymizer.new(&filter_fnc_all)

    purchases = { Purchase.new('airline', 150) => 10, Purchase.new('airline', 10_000) => 5, Purchase.new('airline', 9000) => 1 }
    anonymized_purchases = anonymizer.anonymize_purchases(purchases)

    assert_equal purchases, anonymized_purchases

    stats = anonymizer.resulting_stats

    assert_equal 150, stats[:min]
    assert_equal 10_000, stats[:max]
    assert_equal 3781.25, stats[:avg]
    assert_equal 150, stats[:median]
  end
end
