require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'
require 'sinatra/content_for'

before do
  @users = ["NDF", "Andrew", "Mr. Fish", "trvshlt", "CWK"]
  @stats = ["running", "calories", "weigh-ins", "progress"]
end

get '/' do
  redirect '/summary'
end

get '/summary' do
  "Summary to be added here."
end

