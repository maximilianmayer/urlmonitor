#! /bin/env ruby
#

require_relative 'lib/urlmonitor'
require 'commander/import'

program :name, 'Url monitor'
program :version, '0.2.0-dev'
program :description, 'a simple tool to watch for changes on single urls'

command :list do |c|
  c.syntax = 'list'
  c.description = 'list monitored webpages'
  c.action do |_|
    a = Urlmonitor.new 'http://localhost'
    say 'id'.ljust(6) + 'url'.ljust(60) + "Date".rjust(30)
    a.list_pages.each do |page|
      say page['id'].to_s.ljust(6) + page['url'].ljust(60) + Time.at(page['date']).to_s.rjust(30)
    end
  end
end

command :check do |c|
  c.syntax = 'check <url>'
  c.description = 'check a url for changes. If not checked before, a record will be created.'
  c.option '--url URL', 'The url to check for changes'
  # c.option '--id ID', 'The ID of a stored url'
  c.action do |_,options|
    a = Pagemonitor.new options.url
    a.check_page
    print_summary(a)
  end
end


def print_summary(website)
  puts "Website to check: #{website.url}"
  puts "last checked: #{Time.at(website.last_check).to_s}"
  puts "http status: #{website.status}"
  puts "check status: #{website.last_check_state}"
  puts "checksum: #{website.checksum}"
end
