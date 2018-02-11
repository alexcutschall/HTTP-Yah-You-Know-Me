require 'pry'
require 'socket'
require_relative 'response.rb'

class Server
  attr_reader   :request_lines,
                :client,
                :response,
                :server,
                :total_requests
  attr_accessor :server_loop

  def initialize
    @server         = TCPServer.new(9292)
    @request_lines  = []
    @hello_counter  = 0
    @response       = Response.new(self)
    @total_requests = 0
    @server_loop    = true
  end

  def start
    @client = server.accept

    while @server_loop == true

      puts "Ready for Request"
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      puts "Received request"

      response.handle_requests

      puts "Sent response"

      @total_requests += 1
    end
  end
end

server = Server.new
server.start
