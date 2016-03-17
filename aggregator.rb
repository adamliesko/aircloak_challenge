# Aggregator aggregates purchases added by #add_purchases method on the fly.

class Aggregator
  attr_reader :aggregated_purchases

  def initialize
    @aggregated_purchases = Hash.new(0)
  end

  def add_purchases(purchases)
    purchases.each { |type, amount| @aggregated_purchases[[type, amount]] += 1 }
  end
end
