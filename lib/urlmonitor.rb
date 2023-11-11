#!/bin/env ruby

require 'net/http'
require 'digest'
require 'json'
require 'faraday'
require 'nokogiri'

# core class 
class Urlmonitor

  # Version string
  Version = '0.3.0-dev'
  attr_accessor :url
  attr_reader :url_hash
  attr_reader :checksum
  attr_reader :last_check
  attr_reader :last_check_state
  attr_reader :last_change
  attr_reader :status
  attr_reader :workdir
  attr_reader :debug

  # @param [String] url
  # @param [FalseClass] debug
  # @return [Object]
  def initialize(url,debug=false)
    @url = url
    @workdir = "#{File.expand_path("~")}/.urlmonitor"
    @url_hash = Digest::MD5.hexdigest(url)
    @debug = debug
  end

  # @param [Strinf] dir
  # @return [Dir]
  def prepare(dir)
    Dir.mkdir dir unless File.directory?(dir)
  end

  # @return [Array]
  def list_pages
    file = File.new("#{@workdir}/index.json",'r' )
    JSON.parse(file.read)
  end

  # @param [String] url_hash
  # @return [Hash]
  def page_info(url_hash)
    file_path = "#{@workdir}/#{url_hash}"
    if File.exist?(file_path) # check for existing data
      JSON.load(File.new(file_path,'r').read)
    else
      return {}
    end
  end

  # @return [Hash]
  def add_to_list(data={})
    unless data.empty?
      indexfile_path = "#{@workdir}/index.json"
      if File.exist?(indexfile_path)
        index = JSON.load(File.new(indexfile_path, 'r').read)
      else
        index = []
      end
      data[:id] = index.size + 1
      index.push data
      puts data if @debug
      puts index if @debug
      store(index,indexfile_path,"w")
      return {message: 'success'}
    end
  end

  # @return [Object]
  def check_page
    #res = Net::HTTP.get_response(URI(@url))
    res = Faraday.get(@url)
    @last_check =  Time.now().to_i

  # create a checksum only if request was successful, otherwise make it an empty string
    puts res.class if @debug
    if res.is_a?(Faraday::Response)
      doc = Nokogiri::HTML(res.body)
      doc.xpath("//script").remove

      @checksum = Digest::MD5.hexdigest doc
    else
      @checksum = ''
    end
    @status = res.status

  # create workdir if not already
    self.prepare @workdir
    data ={url: @url, url_hash: @url_hash, content_checksum: @checksum, last_check: @last_check, last_change: @last_change, status: @status, last_check_state: @last_check_state}
    file_path = "#{@workdir}/#{@url_hash}"
    stored_data = page_info @url_hash
    if stored_data.empty?
      puts "no previous page check found. creating a new one at #{file_path}" if @debug
      @last_check_state = 'new'
      @last_change = @last_check
      add_to_list({url: @url, url_hash: @url_hash, date: Time.now.to_i, file: @url_hash})
      store(data, file_path)
    else
      puts "stored data found:  #{stored_data}" if @debug
      unless stored_data['content_checksum'].eql? @checksum
        @last_check_state = 'changed'
        @last_change = @last_check
        store(data, file_path, "w")
      else
        @last_check_state = 'no changes'
        @last_change = stored_data['last_change']
      end
    end
  end

  # @param [Hash,Array] data 
  # @param [String] file_path  
  # @param [String] mode 
  # @return [File]
  def store(data,file_path, mode="a")
    file = File.new(file_path, mode )
    file.write data.to_json
    file.close
  end
end
