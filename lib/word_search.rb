class WordSearch

  def initialize
    @file = File.read('/usr/share/dict/words')
    @dictionary = @file.split("\n")
  end

  def find_word(path)
    word_array = []
    word = path.split("?")[1]
    if word.include?("&")
      word_array << word.split("&")[0].split("=")[1]
      word_array << word.split("&")[1].split("=")[1]
    else
      word_array << word.split("=")[1]
    end
    word_array
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
    end.join("\n")
  end
end
