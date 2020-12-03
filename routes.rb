require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'sinatra/content_for'
require 'bcrypt'
require 'yaml'
require 'sysrandom/securerandom'

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  set :erb, :escape_html => true
end

def logged_in?
  session[:username] ? true : false
end

def validate_user_logged_in
  unless logged_in?
    session[:message] = 'You must be signed in to do that.'
    redirect '/users/login'
  end
end

def valid_credentials?(username, password)
  accounts = load_credentials
  return false unless accounts.key?(username)
  return false unless valid_password?(password, accounts[username])
  true
end

def load_credentials
  if ENV['RACK_ENV'] == 'test'
    path = File.expand_path('../test/users.yml', __FILE__)
  else
    path = File.expand_path('../users.yml', __FILE__)
  end
  YAML.load_file(path)
end

def valid_password?(password, encryted_password)
  BCrypt::Password.new(encryted_password) == password
end

helpers do
  def display_alert
    session.delete(:message)
  end
end

get '/' do
  redirect '/summary'
end

# Display summary of all users information
get '/summary' do
  validate_user_logged_in
  erb :summary
end

# Display login form
get '/users/login' do
  erb :login
end

# Sign in
post '/users/login' do
  if valid_credentials?(params[:username], params[:password])
    session[:username] = params[:username]
    session[:message] = 'Welcome!'
    redirect '/summary'
  else
    status 422
    session[:message] = 'Invalid Credentials'
    erb :login, layout: :layout
  end
end