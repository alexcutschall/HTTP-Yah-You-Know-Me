require 'socket'
require 'pry'

class Response
  attr_reader :server

  def initialize(server)
    @server = server
    @hello_counter = 0
    @output = nil
  end

  def headers
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def debug_information
    verb     = "#{server.request_lines[0].split(" ")[0]}"
    path     = "#{server.request_lines[0].split(" ")[1]}"
    protocol = "#{server.request_lines[0].split(" ")[2]}"
    host     = "#{server.request_lines[1][6..14]}"
    port     = "#{server.request_lines[1][-4..-1]}"
    origin   = "#{server.request_lines[1][6..14]}"

    "<pre>\nVerb: #{verb}\nPath: #{path}\nProtocol: #{protocol}\nHost: #{host}\nPort: #{port}\nOrigin: #{origin}</pre>"
  end

  def hello
    # debug_information
    @output = "Hello World! (#{@hello_counter})\n#{debug_information}"
    headers
    server.client.puts headers
    server.client.puts @output
    @hello_counter += 1
  end

  def debug_page
    # debug_information
    @output = "#{debug_information}"
    headers
    server.client.puts headers
    server.client.puts @output
  end

  def date_time
    @output = "#{Time.now.strftime('%I:%M on %A, %B %d, %Y')}"
    headers
    server.client.puts headers
    server.client.puts @output
  end

  def word_search
    word = server.request_lines[0].split(" ")[1].split("?")
    word_popped = word.shift

    file = File.read('/usr/share/dict/words').split("\n")
    result = word.map do |word|
      if file.include?(word)
        "#{word} is a known word"
      else
        "#{word} is not a known word"
      end
    end.join("\n")

    output = "#{result}"
    # headers
    # server.client.puts headers
    server.client.puts output
  end

    def shutdown
      response = "Total Requests: #{server.total_requests}"
      @output = "#{response}\n#{debug_information}"
      headers
      server.client.puts headers
      server.client.puts @output
      server.server_loop = false
    end


  def verb
    debug_information.split("\n")[0]
  end

  def path
    "#{server.request_lines[0].split(" ")[1]}"
  end

  def handle_requests
    if path == "/hello"
      hello
      server.start
    elsif path == "/"
      debug_page
      server.start
    elsif path == "/datetime"
      date_time
      server.start
    elsif path == "/shutdown"
      shutdown
    else
      word_search
      server.start
    end
  end
end
