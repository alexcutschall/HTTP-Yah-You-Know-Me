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

  response = ["VERB: #{request_lines[0].split(" ")[0]}",
              "Path: #{request_lines[0].split(" ")[1]}",
              "Protocol: #{request_lines[0].split(" ")[2]}",
              "Host: #{request_lines[1][6..14]}",
              "Port: #{request_lines[1][-4..-1]}",
              "Origin: #{request_lines[1][6..14]}",
              "#{request_lines[6][0..7]}\n#{request_lines[6][8..-1]}"].join("\n")
  output = "Hello World! (#{server_requests})\n#{response}"
  headers = ["http/1.1 200 ok",
             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
             "server: ruby",
             "content-type: text/html; charset=iso-8859-1",
             "content-length: #{output.length}\r\n\r\n"].join("\r\n")

  client.puts headers
  client.puts output
  binding.pry
end

puts ["Wrote this response:", headers, output, response].join("\n")
client.close
puts "\nResponse complete, exiting."
