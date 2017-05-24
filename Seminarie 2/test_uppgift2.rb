#! /usr/bin/env ruby

require 'test-unit'
require 'hpricot'

require_relative 'Uppgift2'

class TestUppgift2 < Test::Unit::TestCase

  def test_all
    doc = Hpricot(open('https://www.ida.liu.se/~TDP007/material/seminarie2/events.html'))

    events = HashifyHTML(doc)

    assert_not_nil(events)

    assert_equal(8, events.length)
    assert_equal('Kingston', events[0][:locality])
    assert_equal('Sinister Sundays', events[1][:summary])

  end
end