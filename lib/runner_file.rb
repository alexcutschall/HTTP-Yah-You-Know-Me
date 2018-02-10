require 'socket'
require 'pry'

tcp_server = TCPServer.new(9292)

server_requests = 0
while client = tcp_server.accept
  server_requests += 1

  request_lines = []
  while line = client.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  response = ["<pre>" +
              "VERB: #{request_lines[0]}",
              "Path: /#{request_lines[1]}",
              "Protocol: HTTP/1.1 #{request_lines[2]}",
              "Host: 127.0.0.1 #{request_lines[3]}",
              "Port: 9292 #{request_lines[4]}",
              "Origin: #{request_lines[5]}",
              "Accept: #{{request_lines[6]}}" +
              "</pre>"]
  output = "Hello World! (#{server_requests})"
  headers = ["http/1.1 200 ok",
             "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
             "server: ruby",
             "content-type: text/html; charset=iso-8859-1",
             "content-length: #{output.length}\r\n\r\n"].join("\r\n")

  client.puts headers
  client.puts output
end

client.close
puts "\nResponse complete, exiting."
