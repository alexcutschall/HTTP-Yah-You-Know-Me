require './lib/response'

class Game
  attr_reader :server,
              :guesses

  def initialize
    @random_number     = rand(0..100)
    @guesses           = 0
    @number_guess      = 0
  end

  def guess(user_guess)
    @number_guess = user_guess.to_i
    if @number_guess == @random_number
      @status = 'You got it correct!'
    elsif @number_guess < @random_number
      @status = 'You are too low!'
    else
      @status = 'You are too high!'
    end
    @guesses += 1
  end

  def review
    "\nMost Recent Guess: #{@number_guess}\n" +
    "Number of Guesses: #{@guesses}\n" +
    "Status: #{@status}\n"
  end
end
