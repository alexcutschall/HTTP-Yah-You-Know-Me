require 'socket'
require 'pry'

server = TCPServer.new(9292)
client = server.accept

server_requests = 0
while client = server.accept
  server_requests += 1

  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end



  output = "Hello World! (#{server_requests})\n#{response}"
  headers = ["http/1.1 200 ok",
             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
             "server: ruby",
             "content-type: text/html; charset=iso-8859-1",
             "content-length: #{output.length}\r\n\r\n"].join("\r\n")

  client.puts headers
  client.puts output
end

puts ["Wrote this response:", headers, output, response].join("\n")
client.close
puts "\nResponse complete, exiting."
