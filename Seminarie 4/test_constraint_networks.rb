require_relative 'constraint_networks'
require 'test-unit'

class Test_constraint < Test::Unit::TestCase
  # This is a simple test of the adder constraint network
  def test_adder
    a = Connector.new('a')
    b = Connector.new('b')
    c = Connector.new('c')
    Adder.new(a, b, c)
    a.user_assign(10)
    b.user_assign(5)
    puts 'c = ' + c.value.to_s
    assert_equal(c.value, 15)
    a.forget_value 'user'
    c.user_assign(20)
    # a should now be 15
    puts 'a = ' + a.value.to_s
    assert_equal(a.value, 15)
  end

  # When you use test_constraints, it will prompt you for input before
  # proceeding. That way you can analyze what happens in the code before
  # you go on. You only need to press 'Enter' to continue.

  def test_multiplier
    a = Connector.new('a')
    b = Connector.new('b')
    c = Connector.new('c')

    Multiplier.new(a, b, c)

    a.user_assign(10)
    b.user_assign(5)
    assert_equal(c.value, 50)

    a.forget_value 'user'
    c.user_assign(50)
    assert_equal(a.value, 10)
  end

  def test_c2f
    celsius, fahrenheit = celsius2fahrenheit

    celsius.user_assign 0
    assert_equal(32, fahrenheit.value)

    celsius.user_assign 100
    assert_equal(212, fahrenheit.value)

    celsius.forget_value 'user'
    fahrenheit.user_assign 100
    # prettyprint error... can't resolve it
    assert_equal(37, celsius.value.to_i)
  end
end
