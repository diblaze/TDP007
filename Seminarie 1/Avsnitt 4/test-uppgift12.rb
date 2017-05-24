
require 'test-unit'
require_relative 'Uppgift12'

class TestRegnr < Test::Unit::TestCase
  def test_regnr
    assert_equal('ABC123', regnr('Hej ABC123'))
    assert_equal('ABC123', regnr('ABC123'))
    assert_equal(false, regnr('hej på dig'))
    assert_equal(false, regnr('ÅÖX123'))
    assert_equal(false, regnr('ÅÖX13'))
  end
end
