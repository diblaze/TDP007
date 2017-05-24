require "test-unit"
require_relative "Uppgift9"

class TestUppgift9 < Test::Unit::TestCase
    
    def test_rotate_left
        assert_equal([1,2,3], [3,1,2].rotate_left)
    end
end
