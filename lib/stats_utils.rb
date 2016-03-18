module StatsUtils
  class << self
    def compute_avg_and_median(sorted_purchases, purchases_count)
      sum = 0
      median_array = []

      sorted_purchases.each do |agg_purchase|
        agg_amount = agg_purchase[0].amount
        agg_count = agg_purchase[1]
        median_array += [agg_amount] * agg_count
        sum += agg_amount * agg_count
      end

      median = median(median_array, purchases_count)
      avg = sum.to_f / purchases_count

      [avg, median]
    end

    def median(ordered_array, size)
      return nil if size <= 0 || ordered_array.empty?
      (ordered_array[(size - 1) / 2] + ordered_array[size / 2]) / 2.0
    end

    def min_max_values(sorted_purchases)
      return [nil, nil] if sorted_purchases.empty?
      min = sorted_purchases.first[0].amount
      max = sorted_purchases.last[0].amount

      [min, max]
    end
  end
end