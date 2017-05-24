require_relative("Uppgift3")
require("test-unit")

class TestUppgift3 < Test::Unit::TestCase

    def test_longest_string
        assert_equal(longest_string(["apelsin", "banan", "citron"]), "apelsin")
        #apelsin and bananan is the same length but gives back apelsin because
        #it appears before bananan
        assert_equal(longest_string(["apelsin", "bananan", "citron"]), "apelsin")
    end
end
