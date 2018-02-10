require_relative 'test_helper'
require './lib/server'

class ServerTest < Minitest::Test

  def test_class_is_instantiated
    server = Server.new
    assert_instance_of Server, server
  end

  def test_class_prints_out_hello_world
    assert_equal response.body.include?("Hello, World!"), Faraday.get('http://127.0.0.1:9292')
  end
end
