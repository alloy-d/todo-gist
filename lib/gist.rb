#!/usr/bin/env ruby
require 'gists'

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
    @files[name][:content]
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

