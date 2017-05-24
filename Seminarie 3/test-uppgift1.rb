require 'test-unit'
require './Uppgift1.rb'

class TestPolicy < Test::Unit::TestCase
  def test_person
    kalle = Person.new('Volvo', '58435', 2, 'M', 32)
    assert_not_nil(kalle)
  end

  def test_successful_calc
    kalle = Person.new('Volvo', '58435', 2, 'M', 32)
    assert_equal(15.66, kalle.evaluate_policy('policy.rb'))
    kalle = Person.new('Mercedes', '58937', 16, 'M', 40)
    assert_equal(25, kalle.evaluate_policy('policy.rb'))
  end

  def test_all
    kalle = Person.new('BMW', '58435', 10, 'M', 19)
    assert_not_equal(30, kalle.evaluate_policy('policy.rb'))
  end
end
