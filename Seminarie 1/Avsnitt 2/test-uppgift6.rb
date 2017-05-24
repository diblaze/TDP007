require_relative "Uppgift6"
require "test-unit"

class TestUppgift6 < Test::Unit::TestCase

    def test_initialize
        p = Person.new("Denis Blazevic")
        assert_equal("Denis Blazevic", p.fullname)
        assert_equal(0, p.age)
        assert_equal(0, p.birthyear)

        p = Person.new("Denis Blazevic", 20)
        assert_equal("Denis Blazevic", p.fullname)
        assert_equal(20, p.age)
        assert_equal(1997, p.birthyear)

        p = Person.new("Denis Blazevic", 20, 1997)
        assert_equal("Denis Blazevic", p.fullname)
        assert_equal(20, p.age)
        assert_equal(1997, p.birthyear)

        p = Person.new("Denis Blazevic", 0, 1997)
        assert_equal("Denis Blazevic", p.fullname)
        assert_equal(20, p.age)
        assert_equal(1997, p.birthyear)


        p = Person.new("Denis Blazevic", 20, 0)
        assert_equal("Denis Blazevic", p.fullname)
        assert_equal(20, p.age)
        assert_equal(1997, p.birthyear)
    end

    def test_change_age
        p = Person.new("Denis Blazevic", 20, 1997)
        p.change_age(21)
        assert_equal(21, p.age)
        assert_equal(1996, p.birthyear)
    end

    def test_change_birthyear
        p = Person.new("Denis Blazevic", 20, 1997)
        p.change_birthyear(2000)
        assert_equal(2000, p.birthyear)
        assert_equal(17, p.age)
    end
end
