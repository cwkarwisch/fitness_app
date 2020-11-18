require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'sinatra/content_for'

get '/' do
  redirect '/summary'
end

get '/summary' do
  "Summary to be added here."
end

