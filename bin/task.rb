#!/usr/bin/env ruby
require 'json'
require_relative '../lib/todogist'

if ARGV.length < 1
  STDERR.puts "Provide a command!"
  exit(-1)
end
subcommand = ARGV[0]

task = ARGV[1..ARGV.length].join " "

credentials_file = File.join(ENV["HOME"], ".github_credentials.json")
if not File.exist?(credentials_file)
  STDERR.puts "Put your GitHub credentials in #{credentials_file}!"
  exit(-1)
end

credentials = JSON.load(File.open(credentials_file))
gist = TodoGist.new(credentials["username"], credentials["password"])

case subcommand
when "push"
  gist.push task
when "enqueue"
  gist.enqueue task
when "next"
  puts gist.things[0]
when "list"
  puts gist.things
when "pop"
  puts "FINISHED: " + gist.pop
end
