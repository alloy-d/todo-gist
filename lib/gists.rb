#!/usr/bin/env ruby
require 'gist'
require 'json'
require 'net/http'

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
