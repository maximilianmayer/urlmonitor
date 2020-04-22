#! /bin/env ruby

require_relative 'sitemonitor'
website = ARGV[0]

a = Sitemonitor.new website
a.check_page

## output here
puts "Website to check: #{a.url}"
puts "last checked: #{Time.at(a.last_check).to_s}"
puts "http status: #{a.status}"
puts "check status: #{a.last_check_state}"

