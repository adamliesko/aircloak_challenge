require 'minitest/autorun'
require 'set'

require File.expand_path('../../lib/purchase', __FILE__)

class PurchaseTest < Minitest::Test
  def test_responds_to_type_and_amount
    p = Purchase.new(:food, 100)
    assert_equal :food, p.type
    assert_equal 100, p.amount
  end
end
