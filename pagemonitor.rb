#!/bin/env ruby

require 'net/http'
require 'digest'
require 'json'
# require 'optparse'
#require 'optparse/uri'

class Pagemonitor

  Version = 0.2.2
  attr_accessor :url
  attr_reader :url_hash
  attr_reader :checksum
  attr_reader :last_check
  attr_reader :last_check_state
  attr_reader :last_change
  attr_reader :status
  attr_reader :workdir

  def initialize(url)
    @url = url
    @workdir = 'sitemon'
    @url_hash = Digest::MD5.hexdigest(@url)
  end

  def prepare(dir)
    Dir.mkdir dir unless File.directory?(dir)
  end

  def list_pages
    file = File.new("#{workdir}/index.json",'r' )
    JSON.parse(file.read)
  end

  def add_to_list(data={})
    unless data.empty?
      store(data,"#{workdir}/index.json")
      return {message: 'success'}
    end
  end

  def check_page
    res = Net::HTTP.get_response(URI(@url))
    @last_check =  Time.now().to_i

  # create a checksum only if request was successful, otherwise make it an empty string
    if res.is_a?(Net::HTTPSuccess)
      @checksum = Digest::MD5.hexdigest res.body
    else
      @checksum = ''
    end
    @status = res.code

  # create workdir if not already
    self.prepare @workdir
    data ={url: @url, url_hash: @url_hash, content_checksum: @checksum, last_check: @last_check, last_change: @last_change, status: @status, last_check_state: @last_check_state}
    file_path = "#{@workdir}/#{@url_hash}"
    if File.exist?(file_path) # check for existing data
      file = File.new(file_path, 'r' )
      stored_data = JSON.parse(file.read)
      file.close
      puts "stored data found:  #{stored_data}" if @debug
      unless stored_data['content_checksum'].eql? @checksum
        @last_check_state = 'changed'
        @last_change = @last_check
        store(data,file_path)
      else
        @last_check_state = 'no changes'
        @last_change = stored_data['last_change']
      end
    else
      puts "no previous sitecheck found. creating a new one at #{file_path}" if @debug
      @last_check_state = 'new'
      @last_change = @last_check
      add_to_list({url: @url, url_hash: @url_hash, date: Time.now.to_i, file: @url_hash})
      store(data,file_path)
    end
  end

  def store(data,file_path)
    file = File.new(file_path, 'w' )
    file.write data.to_json
    file.close
  end
end
