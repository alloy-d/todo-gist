#!/usr/bin/env ruby
require 'json'
require_relative './gist.rb'

# A class for managing a to-do list as a Github Gist.
class TodoGist
  attr_reader :things
  def initialize(username, password)
    @gists = Gists.new(username, password)

    @gist = find_gist()
    if @gist.nil?
      @gist = make_gist()
    end

    # Things is a Ruby array of to-do items that is kept in sync with the Gist
    # contents.
    @things = JSON.parse(@gist["list.json"])
  end

  def things=(things)
    @things = things
    update_gist
  end

  # Adds an item to the end of the queue.
  def enqueue(thing)
    @things << thing
    update_gist
  end

  # Pushes an item to the front of the queue.
  def push(thing)
    @things.unshift thing
    update_gist
  end

  # Does the default adding thing (same as enqueue).
  def add_thing(thing)
    enqueue(thing)
  end

  # Removes the first item from the list.
  def pop
    thing = @things.shift
    update_gist
    return thing
  end

  # Returns the first Gist with description "TODO Gist".
  def find_gist
    matches = @gists.get_all.select {|g| g[:description] == "TODO Gist"}
    if matches.length > 0 then
      @gists.get_gist(matches[0][:id])
    else
      nil
    end
  end
  private :find_gist

  # Makes a Gist if none already exists.
  def make_gist
    @gist = Gist.new(:description => "TODO Gist",
                     :public => false)
    @gist["list.json"] = "[]"
    @gists.save @gist
  end
  private :make_gist

  # Updates the Gist with contents of the list.
  # FIXME: this allows more than a responsible number of race conditions.
  def update_gist
    @gist["list.json"] = JSON.pretty_generate @things
    @gists.save @gist
  end
  private :update_gist
end
