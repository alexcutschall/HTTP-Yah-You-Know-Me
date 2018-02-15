require 'pry'
require 'socket'
require './lib/response.rb'
require './lib/controller.rb'

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
    @controller     = Controller.new(self)
    @total_requests = 0
    @server_loop    = true
  end

  def start
    @request_lines = []

    while @server_loop
      @client = server.accept

      puts "Ready for Request"
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      puts "Sent response"

      @total_requests += 1
      @controller.handle_requests
      
      @client.close
    end

  end

end

server = Server.new
server.start
