require './lib/response'
require './lib/game'

class Controller
  attr_reader :server,
              :response,
              :game

  def initialize(server)
    @server   = server
    @response = Response.new(server)
  end

  def path
    "#{server.request_lines[0].split(" ")[1]}"
  end

  def verb
    "#{server.request_lines[0].split(" ")[0]}"
  end

  def guess
    content_length = server.request_lines[3].split(" ")[1].to_i
    client_body = server.client.read(content_length)
    guess = client_body.split[-2]
  end

  def handle_requests
    if verb == "GET"
      handle_get_requests
    else
      handle_post_requests(guess)
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
      response.game
    elsif path.include?"/word"
      response.word_search(path)
    elsif path == "/force_error"
      response.force_error
    else
      response.not_found
    end
  end

  def handle_post_requests(guess)
    if path == "/start_game"
       response.start_game
    elsif path.include?("/game")
       response.post_game(guess)
    else
       response.not_found
     end
   end
end
