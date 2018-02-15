require './test/test_helper'

require './lib/word_search'

class WordSearchTest < Minitest::Test
  def setup
    @word_search = WordSearch.new
  end

  def test_word_can_grab_word_from_path
    assert_equal ["apple", "bana"], @word_search.find_word("/word?word_1=apple&word_2=bana")
  end

  def test_can_find_word
    assert_equal "test is a known word.", @word_search.search('test')
  end

  def test_seach_can_take_two_words
    assert_equal ["apple is a known word.", "bana is not a known word."], @word_search.words("/word?word_1=apple&word_2=bana")
  end
end
