require "test/unit"
require_relative "./Uppgift2.rb"


class TestParser < Test::Unit::TestCase

    def test_all
        lang = TDP007.new
        lang.log(false)

        # New variable
        assert(lang.parse("(set A true)"))
        # Is it True?
        assert(lang.parse("A"))

        assert_false(lang.parse("(set B false)"))
        assert_false(lang.parse("B"))


        assert(lang.parse("(or A B)"))
        assert_false(lang.parse("(and A B)"))
        assert_false(lang.parse("(not A)"))
        assert(lang.parse("(not B)"))
    end
end