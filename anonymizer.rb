# Anonymizer anonymizes the results using filtering function.
# It is then used to computing resulting stats - min, max, avg, mean.

class Anonymizer
  def initialize(&filter)
    @filter = filter
  end

  def anonymize_purchases(purchases)
    @purchases = purchases.select!(&@filter) || []
  end

  def resulting_stats
    if @purchases.size > 0
      sorted_purchases = sort_purchases_by_price
      purchases_count = sorted_purchases.map { |_key, count| count } .inject(0, :+)

      min, max = Anonymizer.set_min_max_values(sorted_purchases)
      avg, median = Anonymizer.compute_stats(sorted_purchases, purchases_count)
    else
      min = max = median = avg = nil
    end
    { min: min, max: max, avg: avg, median: median }
  end

  private

  def sort_purchases_by_price
    @purchases.sort { |key, _count| key[1] }
  end

  def self.compute_stats(sorted_purchases, purchases_count)
    sum = 0
    median = nil
    median_purchase_pos = (purchases_count / 2).ceil

    sorted_purchases.inject(0) do |cummulative_purchases_count, agg_purchase|
      agg_price = agg_purchase[0][1]
      agg_count = agg_purchase[1]

      sum += agg_price * agg_count

      cummulative_purchases_count, median = set_median_if_empty(cummulative_purchases_count, median_purchase_pos, agg_count, agg_price) unless median
      cummulative_purchases_count
    end

    avg = sum.to_f / purchases_count

    [avg, median]
  end

  def self.set_median_if_empty(cummulative_purchases_count, median_purchase_pos, agg_count, agg_price)
    cummulative_purchases_count += agg_count
    median = agg_price if cummulative_purchases_count > median_purchase_pos
    [cummulative_purchases_count, median]
  end

  def self.set_min_max_values(sorted_purchases)
    min = sorted_purchases.first[0][1]
    max = sorted_purchases.last[0][1]

    [min, max]
  end
end
