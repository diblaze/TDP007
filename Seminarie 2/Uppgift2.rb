#! /usr/bin/env ruby

require 'hpricot'
require 'open-uri'

# HTML URL to get
#doc = Hpricot(open('https://www.ida.liu.se/~TDP007/material/seminarie2/events.html'))

def HashifyHTML(doc)
  events = Hash.new

# Find elements
  i=0
  doc.search("//div[@class='vevent']").each do |event|

    # Find tags
    # Summary (used to store in hash table)
    summary = event.search("table/tr/td/span[@class='summary']")
    if !summary.any?
      puts "Can't add current event to hash table because there was no summary given!"
      next
    end

    # Description
    description = event.search("table/tr/td[@class='description']")
    if description.any?
      #puts description.inner_html
    end
    # When
    time = event.search("table/tr/td/table/tr/td/span[@class='dtstart']")
    if time.any?
      #puts time2.inner_html
    end
    # Where
    vcard = event.search("//div[@class='vcard']")
    if vcard.any?
      #puts vcard.inner_html
      street_address = vcard.search("span[@class='street-address']").inner_html
      locality = vcard.search("span[@class='locality']").inner_html
      region = vcard.search("span[@class='region']").inner_html
    else
      street_address = event.search("table/tr/td/table/tr/td/div[@class='adr']/span[@class='street-address']").inner_html
      locality = event.search("table/tr/td/table/tr/td/div[@class='adr']/span[@class='locality']").inner_html
      region = event.search("table/tr/td/table/tr/td/div[@class='adr']/span[@class='region']").inner_html
      end

    events[i] = {:summary => summary.inner_html,
                 :description => description.inner_html,
                 :time => time.inner_html,
                 :street_address => street_address,
                 :locality => locality,
                 :region => region}
    i+=1
  end

  return events
end

