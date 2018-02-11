require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require 'faraday'

class  ResponseTest < MiniTest::Test

  def test_response_includes_GET
    request = Faraday.get('http://127.0.0.1:9292/')
    assert request.body.include?('GET')
  end
end
