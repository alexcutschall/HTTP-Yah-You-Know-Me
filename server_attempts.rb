require 'socket'
require 'pry'

tcp_server = TCPServer.new(9292)
listener = tcp_server.accept

server_requests = 0
request_lines = []
while line = listener.gets and !line.chomp.empty?
  request_lines << line.chomp
end

output = "Hello World! (#{server_requests})"
headers = ["http/1.1 200 ok",
           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{output.length}\r\n\r\n"].join("\r\n")

listener.puts headers
listener.puts output

listener.close
puts "\nResponse complete, exiting."
