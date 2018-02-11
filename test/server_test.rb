require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class ServerTest < Minitest::Test
  def test_response_includes_GET
    request = Faraday.get('http://127.0.0.1:9292/')
    assert request.body.include?('GET')
  end

  def test_class_prints_out_hello_world
    skip
    assert_equal response.body.include?("Hello, World!"), Faraday.get('http://127.0.0.1:9292')
  end
end
