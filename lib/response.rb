require 'socket'
require 'pry'
require './lib/game'
require './lib/word_search'

class Response
  attr_reader :server

  def initialize(server)
    @server = server
    @hello_counter = 0
    @game_started = false
  end

  def debug_information
    "<pre>\n#{server.request_lines.join("\n")}\n</pre>"
  end

  def hello
    response("Hello World! (#{@hello_counter})")
    @hello_counter += 1
    #
  end

  def debug_page
    response(debug_information)
    #
  end

  def date_time
    response(Time.now.strftime('%I:%M on %A, %B %d, %Y'))
    # #
  end

  def shutdown
    response("Total Requests: #{server.total_requests}")
    server.server_loop = false
  end

  def word_search(path)
    word_search = WordSearch.new
    response(word_search.words(path))
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
    #
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
    #
  end

  def force_error
    response("Internal Server Error", {status: "http/1.1 500 Internal Server Error"})
    #
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
