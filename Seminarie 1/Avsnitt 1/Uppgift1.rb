#!/usr/bin/env ruby
def n_times(timesToRepeat)
  1.upto(timesToRepeat) { yield }
end

class Repeat
  def initialize(count)
    @count = count
  end

  def each
    # because we send in a code block, we can yield (take that code block and replace the yield keyword with the block we want)
    @count.times { yield }
  end
end
