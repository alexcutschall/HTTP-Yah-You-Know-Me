require "./test/test_helper"
require './lib/game'

class GameTest < Minitest::Test
  def class_can_be_initiated
    game = Game.new
    assert_instance_of Game, game
  end

  def class_can_take_a_high_number
    Game.new
    assert_equal 50, guess(50)
  end

  def class_has_a_guesses_attribute_defaulted_to_0
    game = Game.new
    assert_equal 0, game.guesses
  end

  def class_
end
