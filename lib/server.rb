require 'pry'
require 'socket'

class Server
  attr_reader :request_lines,
              :client,
              :response,
              :server


  def initialize
    @server = TCPServer.new(9292)
    @request_lines = []
    @hello_counter = 0
    @response = Response.new(self)
  end

  def start
    @client = server.accept
    loop do
      puts "Ready for Request"
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      puts "received request"
      response.hello
      puts "sent response"
    end
  end

  class Response
    attr_reader :server

    def initialize(server)
      @server = server
      @hello_counter = 0
    end

    def hello
      debug_information
      output = "Hello World! (#{@hello_counter})\n#{debug_information}"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      server.client.puts headers
      server.client.puts output
      puts ["Wrote this response:", headers, output].join("\n")
      puts "\nResponse complete, exiting."
      @hello_counter += 1
      server.start
    end

    def debug_information
      response = ["VERB: #{@server.request_lines[0].split(" ")[0]}",
                  "Path: #{@server.request_lines[0].split(" ")[1]}",
                  "Protocol: #{@server.request_lines[0].split(" ")[2]}",
                  "Host: #{@server.request_lines[1][6..14]}",
                  "Port: #{@server.request_lines[1][-4..-1]}",
                  "Origin: #{@server.request_lines[1][6..14]}",
                  "#{@server.request_lines[6][0..7]}\n#{@server.request_lines[6][8..-1]}"].join("\n")
    end
end
end

server = Server.new
server.start
