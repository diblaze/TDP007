require 'test-unit'
require_relative 'Uppgift10'

class TestUsername < Test::Unit::TestCase

  def test_username
    assert_equal("Gustav", find_username("Username: Gustav"))
    assert_equal("Gustav", find_username("hej på dig: Gustav"))
  end
  end