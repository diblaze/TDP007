require_relative("Uppgift5")
require("test-unit")

class TestUppgift5 < Test::Unit::TestCase

    def text_initialize
        p = PersonName.new()
        assert_equal(" ", p.fullname)

        p = PersonName.new("Denis Blazevic")
        assert_equal("Denis Blazevic", p.fullname)
    end

    def test_fullname
        p = PersonName.new()
        p.fullname = "Denso So"
        assert_equal("Denso So", p.fullname)
    end
end
