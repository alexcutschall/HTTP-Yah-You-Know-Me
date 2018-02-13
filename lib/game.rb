require './lib/response'

class Game

  def initialize(server)
    @number = rand(0..100)
    @server = server
    @response = Response.new(server)
  end

  def start_game
    @response.response("Good luck!")
    binding.pry
  end

end

# 1) Pick a random number between 0 and 100
# 2) player can make a new guess by sending a Post request containing
#the number they want to guess
# 3) When the player requests the Game path, server should show
#information about game like number of guess, most recent guess,
#whether it was too high or low or correct

#Post to /start_game
#starts game and puts "Good luck!"

#Post to /game?guess=guess goes here
#server stores guess and redirects user response to a GET to /game

#Get to /game
#How many guesses have been made etc?
