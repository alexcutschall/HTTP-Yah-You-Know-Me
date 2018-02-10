require 'socket'

server = TCPServer.new(9292) #server bind to port 9292, or the mailbox
loop do
  listener = server.accept #wait for a client to connect
  listener.puts "Hello World!"
  listener.close
end
