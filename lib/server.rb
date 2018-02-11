require 'pry'
require 'socket'

class Server
  def initialize
    @server = TCPServer.new(9292)
    @request_lines = []
    @hello_counter = 0
  end

  def start
    @client = @server.accept
    loop do
      puts "Ready for Request"
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      response
    end
  end

  def response
    debug_information
    output = "Hello World! (#{@hello_counter})\n#{debug_information}"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete, exiting."
    @hello_counter += 1
    start
  end

  def debug_information
    response = ["VERB: #{@request_lines[0].split(" ")[0]}",
                "Path: #{@request_lines[0].split(" ")[1]}",
                "Protocol: #{@request_lines[0].split(" ")[2]}",
                "Host: #{@request_lines[1][6..14]}",
                "Port: #{@request_lines[1][-4..-1]}",
                "Origin: #{@request_lines[1][6..14]}",
                "#{@request_lines[6][0..7]}\n#{@request_lines[6][8..-1]}"].join("\n")
  end
end

server = Server.new
server.start
