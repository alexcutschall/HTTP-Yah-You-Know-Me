require './lib/response'

class Game
  attr_reader :server,
              :guesses

  def initialize
    @number            = rand(0..100)
    @guesses           = 0
    @number_guess      = 0
  end


  def guess(guess)
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
    "\nMost Recent Guess: #{@number_guess}\nNumber of Guesses: #{@guesses}\nStatus: #{@status}\n"
  end
end

#server stores guess and redirects user response to a GET to /game
