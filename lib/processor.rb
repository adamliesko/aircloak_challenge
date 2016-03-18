require 'json'
require 'set'
require File.expand_path('../../lib/aggregator', __FILE__)
require File.expand_path('../../lib/anonymizer', __FILE__)

# Processor processes json input files and delegates the stats computation to other classes.
class Processor
  def initialize(aggregator, anonymizer, path)
    @aggregator = aggregator
    @anonymizer = anonymizer
    @path = path
  end

  def process_user_files(type)
    Dir.glob(File.join(@path.to_s, '*.json')) do |json_file_name|
      purchases = parse_user_purchases_file(json_file_name, type)
      @aggregator.add_purchases(purchases)
    end

    @anonymizer.anonymize_purchases(@aggregator.aggregated_purchases)
    @anonymizer.resulting_stats
  end

  def self.unique_user_purchases_of_type(purchases, type)
    unique_purchases = Set.new
    purchases.each do |purchase|
      next if purchase['type'] != type
      unique_purchases << Purchase.new(purchase['type'], purchase['amount'])
    end
    unique_purchases
  end

  private

  def parse_user_purchases_file(json_file_name, type)
    file = File.read(json_file_name)
    user_data = JSON.parse(file)
    Processor.unique_user_purchases_of_type(user_data['purchases'], type.to_s)
  end
end
