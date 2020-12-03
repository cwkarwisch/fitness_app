ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../routes'

class FitnessTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def admin_session
    {"rack.session" => { username: "admin" } }
  end

  def sign_in_user
    post '/users/login', params={username: "admin", password: "supersecret"}
  end

  def test_summary_as_signed_out_user
    get '/summary'

    assert_equal 302, last_response.status

    get last_response['Location']

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'You must be signed in to do that.'
  end

  def test_summary_as_signed_in_user
    get '/summary', {}, admin_session

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Summary of Everyone's Stats Here"
  end

  def test_sign_in
    sign_in_user

    assert_equal 302, last_response.status

    get last_response['Location']

    assert_equal 200, last_response.status
    assert_equal "admin", last_request.session[:username]
    assert_includes last_response.body, 'Welcome!'
  end

  def test_failed_login
    post '/users/login', params={username: "testname", password: "password"}

    assert_equal 422, last_response.status

    assert_includes last_response.body, 'Invalid Credentials'
  end

  def test_login_page
    get '/users/login'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Username'
    assert_includes last_response.body, 'Password'
    assert_includes last_response.body, 'Sign In'
    assert_includes last_response.body, '<input'
    assert_includes last_response.body, '<button type="submit"'
  end
end
