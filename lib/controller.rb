require './lib/response'
require './lib/game'

class Controller
  attr_reader :server,
              :response,
              :game

  def initialize(server)
    @server   = server
    @response = Response.new(server)
    @game     = Game.new
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
      # content_length = server.request_lines[3].split(" ")[1].to_i
      # client_body = server.client.read(content_length)
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
    if path == "/start_game"
       response.start_game
    else
       user_guess = server.request_lines[3].split(" ")[1].to_i
       response.post_game(user_guess)
     end
     server.start
   end
end
