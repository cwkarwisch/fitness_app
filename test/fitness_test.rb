ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../routes'

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_summary
    get '/summary'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Summary to be added here.'
  end
end
