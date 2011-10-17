#!/usr/bin/env ruby
require 'json'
require 'todo-gist'

subcommand = ARGV[0] || "next"

if ARGV.length > 0
  task = ARGV[1..ARGV.length].join " "
else
  task = nil
end

credentials_file = File.join(ENV["HOME"], ".github_credentials.json")
if not File.exist?(credentials_file)
  STDERR.puts "Put your GitHub credentials in #{credentials_file}!"
  exit(-1)
end

credentials = JSON.load(File.open(credentials_file))
gist = TodoGist.new(credentials["username"], credentials["password"])

case subcommand
when "push"
  gist.push task unless task.nil?
when "enqueue"
  gist.enqueue task unless task.nil?
when "next"
  puts gist.things[0]
when "list"
  puts gist.things
when "pop"
  puts "FINISHED: " + gist.pop
end
