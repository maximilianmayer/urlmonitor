#! /bin/env ruby
#

require_relative 'lib/pagemonitor'
require 'commander/import'
program :name, 'Page monitor'
program :version, '0.2-dev'
program :description, 'a simple tool to watch for changes on single webpages'

command :list do |c|
  c.syntax = 'list'
  c.description = 'list monitored webpages'
  c.action do |_|
    a = Pagemonitor.new 'http://localhost'
    a.list_pages.each do |page|
      puts [page['url'], Time.at(page['date'])].join(' - ')
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
