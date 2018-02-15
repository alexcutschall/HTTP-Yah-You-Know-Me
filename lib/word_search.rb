class WordSearch

  def initialize
    @file = File.read('/usr/share/dict/words')
    @dictionary = @file.split("\n")

  end

  def find_word(path)
    word_array = []
    word = path.split("?")
    word_array << word1 = word[1].split("&")[0].split("=")[1]
    word_array <<word[1].split("&")[1].split("=")[1]
  end

  def search(word)
      if @dictionary.include?(word)
        "#{word} is a known word."
      else
        "#{word} is not a known word."
      end
  end

  def words(path)
    find_word(path).map do |word|
      search(word)
    end
  end
end

word = WordSearch.new
word.find_word("/word?word_1=apple&word_2=bana")
