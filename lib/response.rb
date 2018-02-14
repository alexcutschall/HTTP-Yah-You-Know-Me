require 'socket'
require 'pry'
require './lib/game'

class Response
  attr_reader :server

  def initialize(server)
    @server = server
    @hello_counter = 0
    @game_started = false
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
    response("Hello World! (#{@hello_counter})")
    @hello_counter += 1
    server.start
  end

  def debug_page
    response(debug_information)
    server.start
  end

  def date_time
    response(Time.now.strftime('%I:%M on %A, %B %d, %Y'))
    server.start
  end

  def shutdown
    response("Total Requests: #{server.total_requests}")
    server.server_loop = false
  end

#put into a separate class? It ONLY takes two params like this. Need to refactor
  def word_search
    word_array = []
    word = server.request_lines[0].split(" ")[1].split("?")
    word_array << word1 = word[1].split("&")[0].split("=")[1]
    word_array <<word[1].split("&")[1].split("=")[1]

    file = File.read('/usr/share/dict/words').split("\n")
    result = word_array.map do |word|
      if file.include?(word)
        "#{word} is a known word"
      else
        "#{word} is not a known word"
      end
    end.join("\n")

    response(result)
  end

  def start_game
    if @game_started == true
      response("You already have a game going!", {status: "http/1.1 403 Forbidden"})
    else
       @game = Game.new
       @game_started = true
       headers = ["HTTP/1.1 302 redirect",
                  "location: /game",
                  "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                  "server: ruby\r\n\r\n"].join("\r\n")

       server.client.puts headers
     end
  end

  def game
    if @game_started == true
       response(@game.review)
    else
      response("You haven't started a game yet! Make a post request to /start_game.",
              {status: "http/1.1 403 Forbidden"})
    end
    server.start
  end

  def post_game(user_guess)
    if @game_started == true
       @game.guess(user_guess)
       headers = ["HTTP/1.1 302 redirect",
                  "location: /game",
                  "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                  "server: ruby\r\n\r\n"].join("\r\n")

       server.client.puts headers
    else
      response("You haven't started a game yet! Make a post request to /start_game.",
               {status: "http/1.1 403 Forbidden"})
    end
  end

  def not_found
    response("Sorry, we don't know where that is!", {status: "http/1.1 404 Not Found"})
    server.start
  end

  def force_error
    response("Internal Server Error", {status: "http/1.1 500 Internal Server Error"})
    server.start
  end

  def response(body, status_input = {})
    output = "<html><head></head><body>#{body}</body></html>"
    status = status_input[:status] || "http/1.1 200 ok"
    headers = [status,
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")

    server.client.puts headers
    server.client.puts output
  end
end
