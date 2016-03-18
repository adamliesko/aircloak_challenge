require File.expand_path('../../lib/purchase', __FILE__)

# Aggregator aggregates purchases added by #add_purchases method on the fly
class Aggregator
  attr_reader :aggregated_purchases

  def initialize
    @aggregated_purchases = Hash.new(0)
  end

  def add_purchases(purchases)
    purchases.each { |purchase| @aggregated_purchases[purchase] += 1 }
  end
end
