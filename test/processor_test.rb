require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/processor', __FILE__)

class ProcessorTest < Minitest::Test
  def test_unique_user_purchases_of_type_creates_set_of_unique_purchases_of_a_certain_type
    purchases = [{ 'type' => 'hotel', 'amount' => 460 },
                 { 'type' => 'airline', 'amount' => 150 },
                 { 'type' => 'car', 'amount' => 928_759 },
                 { 'type' => 'hotel', 'amount' => 460 },
                 { 'type' => 'drink', 'amount' => 6 },
                 { 'type' => 'airline', 'amount' => 150 },
                 { 'type' => 'car', 'amount' => 928_759 },
                 { 'type' => 'hotel', 'amount' => 460 },
                 { 'type' => 'car', 'amount' => 928_759 },
                 { 'type' => 'airline', 'amount' => 10_000 },
                 { 'type' => 'airline', 'amount' => 10_000 }]

    assert_equal Set.new([Purchase.new('car', 928_759)]), Processor.unique_user_purchases_of_type(purchases, 'car')
    assert_equal Set.new([Purchase.new('airline', 10_000), Purchase.new('airline', 150)]), Processor.unique_user_purchases_of_type(purchases, 'airline')
  end

  def test_process_user_files_processes_user_files_from_directory_and_returns_resulting_stats
    stub_aggregator_and_anonymizer

    @processor = Processor.new(@aggregator_stub, @anonymizer_stub, '../data/')
    stats = @processor.process_user_files('airline')
    assert_equal 150, stats[:min]
    assert_equal 150, stats[:max]
    assert_equal 150, stats[:avg]
    assert_equal 150, stats[:median]
  end

  def stub_aggregator_and_anonymizer
    @aggregator_stub = Object.new
    @anonymizer_stub = Object.new

    def @aggregator_stub.add_purchases(_, _call_count = nil)
      [{ Purchase.new('airline', 150) => 10 }]
    end

    def @aggregator_stub.aggregated_purchases
      [{ Purchase.new('airline', 150) => 10 }]
    end

    def @anonymizer_stub.anonymize_purchases(_)
      [{ Purchase.new('airline', 150) => 10 }]
    end

    def @anonymizer_stub.resulting_stats
      { min: 150, max: 150, avg: 150, median: 150 }
    end
  end
end
