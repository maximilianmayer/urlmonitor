#!/bin/env ruby

require 'net/http'
require 'digest'
require 'json'
require 'optparse'
require 'optparse/uri'

class Sitemonitor


  debug = false
  site = {'url' => ARGV[0], 'url_hash' => Digest::MD5.hexdigest(ARGV[0]), 'content_checksum' => '' , 'status' => '', 'last_check' => 0, 'last_change' => 0 }
  site_uri = URI(site['url'])
  workdir = 'sitemon'
  file_path = "#{workdir}/#{site['url_hash']}"
  res = Net::HTTP.get_response(site_uri)
  site['last_check'] =  Time.now().to_i

  def prepare(workdir)
    Dir.mkdir workdir unless File.directory?(workdir)
  end

  # create a checksum only if request was successful, otherwise make it an empty string
  if res.is_a?(Net::HTTPSuccess)
    site['content_checksum'] = Digest::MD5.hexdigest res.body
  else
    site['content_checksum'] = ''
  end
  site['status'] = res.code


  puts site if debug

  if File.exist? (file_path)
    file = File.new(file_path, 'r' )
    stor_data = JSON.parse(file.read)
    file.close
    puts "stored data:  #{stor_data}" if debug
    puts "checking for changes on #{site_uri}"
    print "last checked at #{Time.at(stor_data['last_check'])}"
    unless stor_data['content_checksum'].eql? site['content_checksum']
      print  "\t => content changed!\n"
      site['last_change'] = site['last_check']
    else
      print "\t => no changes!\n"
      site['last_change'] = stor_data['last_change']
    end
  else
    puts "no previous sitecheck found. creating a new one at #{file_path}"
    site['last_change'] = site['last_check']
  end
  file = File.new(file_path, 'w' )
  file.write site.to_json
  file.close


end