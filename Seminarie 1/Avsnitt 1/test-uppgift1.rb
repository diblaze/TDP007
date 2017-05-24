require_relative('Uppgift1')
require('test-unit')

class TestUppg1 < Test::Unit::TestCase
  def test_n_times
    i = 2
    n_times(3) { i *= 2 }
    assert_equal(i, 16)
  end

  def test_repeat
    r = Repeat.new(3)
    i = 2
    r.each { i *= 2 }
    assert_equal(i, 16)

    r = Repeat.new(5)
    i = 1
    r.each { i += 1 }
    assert_equal(i, 6)
  end
end
