#! /bin/env ruby

require_relative 'pagemonitor'
website = ARGV[0]

a = Pagemonitor.new website
a.check_page

## output here
puts "Website to check: #{a.url}"
puts "last checked: #{Time.at(a.last_check).to_s}"
puts "http status: #{a.status}"
puts "check status: #{a.last_check_state}"

