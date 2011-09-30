#!/usr/bin/env ruby
require 'json'
require './gist.rb'

class TodoGist
  attr_reader :things
  def initialize(username, password)
    @gists = Gists.new(username, password)

    @gist = find_gist()
    if @gist.nil?
      @gist = make_gist()
    end

    @things = JSON.parse(@gist["list.json"])
  end

  def things=(things)
    @things = things
    update_gist
  end

  def add_thing(thing)
    @things << thing
    update_gist
  end

  def find_gist
    matches = @gists.get_all.select {|g| g[:description] == "TODO Gist"}
    if matches.length > 0 then
      @gists.get_gist(matches[0][:id])
    else
      nil
    end
  end
  private :find_gist

  def make_gist
    @gist = Gist.new(:description => "TODO Gist",
                     :public => false)
    @gist["list.json"] = "[]"
    @gists.save @gist
  end
  private :make_gist

  def update_gist
    @gist["list.json"] = JSON.pretty_generate @things
    @gists.save @gist
  end
  private :update_gist
end
