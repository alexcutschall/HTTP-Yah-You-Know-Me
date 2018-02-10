require 'socket'
require 'pry'
require './lib/server'

server = Server.new
server.start
server.response
server.output
server.headers
server.puts headers
server.puts output

puts "Wrote this response:"
client.close
puts "\nResponse complete, exiting."
