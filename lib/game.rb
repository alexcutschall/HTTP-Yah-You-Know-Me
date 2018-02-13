require './lib/response'

class Game
  attr_reader :server,
              :guesses

  def initialize(server)
    @number            = rand(0..100)
    @server            = server
    @response          = Response.new(server)
    @guesses           = 0
    @number_guess      = 0
  end

  def start_game
    @response.response("Good luck!")
    server.start
  end

  def guess
    guess = server.request_lines[0].split(" ")[1]
    @number_guess = guess.split("=")[1].to_i
    if @number_guess == @number
      @guesses += 1
      @response.response("You got it correct!")
    elsif @number_guess < @number
      @guesses += 1
      @response.response("You are too low!")
    else
      @guesses += 1
      @response.response("You are too high!")
    end
    status
    server.start
  end

  def status
    if @number_guess == @number
      @status = "You got it correct!"
    elsif @number_guess < @number
      @status = "You are too low!"
    else
      @status = "You are too high!"
  end
end


  def review
    @response.response("\nMost Recent Guess: #{@number_guess}\nNumber of Guesses: #{@guesses}\nStatus: #{@status}\n")
    server.start
  end

end

# 3) When the player requests the Game path, server should show
#information about game like number of guess, most recent guess,
#whether it was too high or low or correct

#Post to /start_game
#starts game and puts "Good luck!"

#Post to /game?guess=guess goes here
#server stores guess and redirects user response to a GET to /game

#Get to /game
#How many guesses have been made etc?
