require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do 
  erb :index
end

get '/form' do 
  erb :form
end

post '/myaction' do
  puts params[:name]
end


