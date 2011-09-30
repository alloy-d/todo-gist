#!/usr/bin/env ruby
require 'net/http'
require 'json'

class Gist
  attr_accessor :id, :description, :public, :files
  def initialize(hash)
    @id = hash[:id]
    @description = hash[:description]
    @public = hash[:public]
    @files = hash[:files] || {}
  end

  def to_hash
    hash = {
      :description => @description,
      :public => @public,
      :files => @files,
    }
    hash[:id] = @id if not @id.nil?

    hash
  end

  def to_json(*a)
    self.to_hash.to_json(*a)
  end

  def [](name)
    @files[name]
  end

  def []=(name, body)
    if @files[name].nil? then
      @files[name] = {}
    end
    @files[name][:content] = body
  end

  def self.json_create(hash)
    files = {}
    hash[:files].each do |k,v|
      files[k.to_s] = {:content => v[:content]}
    end

    hash[:files] = files

    new(hash)
  end
end

class Gists
  API_ROOT = "api.github.com"
  def initialize(username, password)
    @username = username
    @password = password
  end

  def get(resource)
    Net::HTTP.start(API_ROOT, :use_ssl => true) do |http|
      req = Net::HTTP::Get.new(resource)
      req.basic_auth @username, @password
      response = http.request(req)
      
      JSON.parse(response.body, :symbolize_names => true)
    end
  end

  def post(resource, body)
    Net::HTTP.start(API_ROOT, :use_ssl => true) do |http|
      req = Net::HTTP::Post.new(resource)
      req.basic_auth @username, @password
      req.body = body
      response = http.request(req)

      JSON.parse(response.body, :symbolize_names => true)
    end
  end

  def get_all
    get("/gists")
  end

  def get_gist(id)
    Gist.json_create(get("/gists/#{id}"))
  end

  def save(gist)
    if not gist.id.nil? then
      post "/gists/#{gist.id}", gist.to_json
    else
      res = post "/gists", gist.to_json
      gist.id = res["id"]
      res
    end
  end
end
