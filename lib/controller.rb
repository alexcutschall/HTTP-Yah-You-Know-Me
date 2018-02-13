require './lib/response'
require './lib/game'

class Controller
  attr_reader :server,
              :response,
              :game

  def initialize(server)
    @server   = server
    @response = Response.new(server)
    @game     = Game.new(server)
  end

  def path
    "#{server.request_lines[0].split(" ")[1]}"
  end

  def verb
    "#{server.request_lines[0].split(" ")[0]}"
  end

  def handle_requests
    if verb == "GET"
      handle_get_requests
    else
      handle_post_requests
    end
  end

  def handle_get_requests
    if path == "/hello"
      response.hello
    elsif path == "/"
      response.debug_page
    elsif path == "/datetime"
      response.date_time
    elsif path == "/shutdown"
      response.shutdown
    elsif path == "/game"
      game.review
    else
      response.word_search
    end
  end

  def handle_post_requests
  server.request_lines[3]
    if path == "/start_game"
       game.start_game
    else
       game.guess
     end
   end
end
