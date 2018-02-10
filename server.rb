require 'socket'
#this is our server instance and listens on port 9292
tcp_server = TCPServer.new(9292)
listener = tcp_server.accept


puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

#when the program runs it'll "hang" on the gets method
#call waiting for a request to come in
puts "Got this request:"
puts request_lines.inspect

#Now it's time to build a response
puts "Sending response."
response = "<pre>" + request_lines.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
           "date: #{Time.now.strftime('%a, %e %b %Y $H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client puts output

#Now close the server
puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
