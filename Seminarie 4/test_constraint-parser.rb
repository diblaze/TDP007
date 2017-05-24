#!/usr/bin/env ruby
# -*- coding:utf-8 -*-

require_relative 'constraint-parser'
require 'test-unit'

class TestParser < Test::Unit::TestCase
  def test_parser
    cp = ConstraintParser.new
    c, f = cp.parse '9*c=5*(f-32)'

    c.user_assign 90
    assert_equal(194, f.value.to_i)

    c.user_assign 0
    assert_equal(32, f.value.to_i)

    c.forget_value 'user'
    f.user_assign 0
    assert_equal(-18, c.value.to_i)

    f.user_assign 100
    assert_equal(37, c.value.to_i)

    # area of a triangle
    a, b, h = cp.parse 'a=(b*h)/2'

    a.user_assign 5
    b.user_assign 2
    assert_equal(5, h.value.to_i)

    a.forget_value 'user'
    h.user_assign 10
    assert_equal(10, a.value.to_i)
  end
end
