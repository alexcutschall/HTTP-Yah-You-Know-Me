require 'socket'
require 'pry'

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
  end

  def debug_page
    debug_information
    output = "#{debug_information}"
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    server.client.puts headers
    server.client.puts output
  end

  def date_time
    date = Time.now.strftime('%I:%M on %A, %B %d, %Y')
    output = "#{date}\n#{debug_information}"
    headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    server.client.puts headers
    server.client.puts output
  end

  def debug_information
    verb =  "#{server.request_lines[0].split(" ")[0]}",
    path =  " #{server.request_lines[0].split(" ")[1]}",
    protocol " #{server.request_lines[0].split(" ")[2]}",
    host =  " #{server.request_lines[1][6..14]}",
    port =  " #{server.request_lines[1][-4..-1]}",
    origin =  " #{server.request_lines[1][6..14]}" ].join("\n")
    "#{server.request_lines[6][0..7]}\n#{server.request_lines[6][8..-1]}"
     "<pre>"
     "VERB: #{verb}"
     "Path: #{path}"
     "Protocol: #{protocol}"
     "Host: #{host}"
     "Port: #{port}"
     "Origin: #{origin}"
     binding.pry
     "<pre>"
  end

  def word_search
    word = debug_information.split("\n")[1].split("?")
    word_popped = word.shift
    file = File.read('/usr/share/dict/words').split("\n")
    result = word.map do |word|
      if file.include?(word)
        "#{word} is a known word"
      else
        "#{word} is not a known word"
      end
    end
  end

    def shutdown
      puts "Total Requests: #{server.total_requests}"
      server.server_loop = false
    end

  def verb
    debug_information.split("\n")[0]
  end

  def path
    debug_information.split("\n")[1].split(":")[1].strip
  end

  def handle_requests
    if path == "/hello"
      hello
    elsif path == "/"
      debug_page
    elsif path == "/datetime"
      date_time
    elsif path == "/shutdown"
      shutdown
    else
      word_search
    end
    server.start
  end
end
