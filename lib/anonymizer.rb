require File.expand_path('../../lib/stats_utils', __FILE__)

# Anonymizer anonymizes the results using filtering function
# It is afterwards used to compute resulting stats - min, max, avg, mean through StatsUtils module
class Anonymizer
  def initialize(&filter)
    @filter = filter
  end

  def anonymize_purchases(purchases)
    @purchases = purchases.select(&@filter) || []
  end

  def resulting_stats
    sorted_purchases = sort_purchases_by(:amount)
    purchases_count = sorted_purchases.map { |_purchase_kind, count| count } .inject(0, :+)

    min, max = StatsUtils.min_max_values(sorted_purchases)
    avg, median = StatsUtils.compute_avg_and_median(sorted_purchases, purchases_count)

    { min: min, max: max, avg: avg, median: median }
  end

  private

  def sort_purchases_by(attr)
    @purchases.sort_by { |purchase_kind, _count| purchase_kind.send(attr) }
  end
end
