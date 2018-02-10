require 'pry'
require 'socket'

class Server
  attr_reader :client

  def initialize
    @server              = TCPServer.new 9292
    @server_requests     = 0
  end

  def start
    @client = @server.accept
    while @client = @server.accept
      @server_requests += 1
      @request_lines = []
        while line = client.gets and !line.chomp.empty?
          @request_lines << line.chomp
        end
      client.close
    end
  end

  def response
      response = ["VERB: #{@request_lines[0].split(" ")[0]}",
                  "Path: #{@request_lines[0].split(" ")[1]}",
                  "Protocol: #{@request_lines[0].split(" ")[2]}",
                  "Host: #{@request_lines[1][6..14]}",
                  "Port: #{@request_lines[1][-4..-1]}",
                  "Origin: #{@request_lines[1][6..14]}",
                  "#{@request_lines[6][0..7]}\n#{@request_lines[6][8..-1]}"].join("\n")
  end

  def output
    output = "Hello World! (#{@server_requests - 1})\n{response}"
  end

  def headers
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end
end
