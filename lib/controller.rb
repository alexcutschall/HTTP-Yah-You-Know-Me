class Controller
  attr_reader :server,
              :response

  def initialize(server)
    @server = server
    @response = Response.new(server)
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
    else
      response.word_search
    end
  end

  def handle_post_requests
  server.request_lines[3]
  binding.pry
  end
end
