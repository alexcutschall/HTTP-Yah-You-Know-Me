require 'socket'
require 'pry'
#server bind to port 9292, or the mailbox
tcp_server = TCPServer.new(9292)
#wait for a client to connect
listener = tcp_server.accept


puts "Ready for a request"
request_lines = []
#this first part does assignment and it also checks if it isn't empty
while line = listener.gets and !line.chomp.empty?
  request_lines << line.chomp
end
#This is where the actual request is

#when the program runs it'll "hang" on the gets method
#call waiting for a request to come in
puts "Got this request:"
#Inspect returns the information but just in plain english
puts request_lines.inspect

#Now it's time to build a response
puts "Sending response."
#This is just formatting the response coming back to you with formatting
response = "<pre>" + request_lines.join("\n") + "</pre>"
#This just puts the output into html tags, but why?
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
  #This is just formatting the time
           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{output.length}\r\n\r\n"].join("\r\n")
#This actually puts to the screen
listener.puts headers
listener.puts output

#Now close the server
puts ["Wrote this response:", headers, output].join("\n")
listener.close
puts "\nResponse complete, exiting."
