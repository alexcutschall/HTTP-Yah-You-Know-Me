require_relative 'test_helper'
require './lib/response'


class ServerTest < Minitest::Test
  def test_response_includes_GET
    request = Faraday.get('http://127.0.0.1:9292')
    assert request.body.include?('GET')
  end

  def test_class_prints_out_hello_world
    request = Faraday.get('http://127.0.0.1:9292/hello')
    assert request.body.include?('Hello World!')
  end

  def test_class_prints_out_date
    request = Faraday.get('http://127.0.0.1:9292/datetime')
    assert request.body.include?('2018')
  end

  def test_class_prints_out_word_search
    request = Faraday.get('http://127.0.0.1:9292/word?apple?ban')
    assert request.body.include?('known')
  end

  def test_prints_not_found_if_wrong_path
    request = Faraday.get('http://127.0.0.1:9292/sleepy')
    assert request.body.include?('Sorry')
  end

  def test_can_force_an_error
    request = Faraday.get('http://127.0.0.1:9292/force_error')
    assert request.body.include?('Internal')
  end
end
