require "test-unit"
require_relative "Uppgift8"

class TestUppgift8 < Test::Unit::TestCase

    def test_acronym
        assert_equal("OMG","Oh my god".acronym)
        assert_equal("LOL","laughing out loud".acronym)
        assert_equal("WYD","what you doing".acronym)
    end
end
