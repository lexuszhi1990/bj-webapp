require 'rubygems'
require 'sinatra'
require "pry"
require "./blackjack.rb"

set :sessions, true

get '/' do 
  erb :index
end

get '/login' do 
  erb :login
end

get '/logout' do
  session[:name] = nil
  redirect '/'
end

post '/user_create' do
  if !params[:name].empty?
    session[:name] = params[:name]
    redirect '/game'
  else
    @error = "Must input a name"
    erb :login
  end
end

def startup
  puts "game start up"
  session[:deck] = Deck.new
  session[:player] = Player.new(session[:name])
  session[:player].add_card(session[:deck].deal_one)
  session[:player].add_card(session[:deck].deal_one)
end

get '/game' do
  if session[:name].nil?
    @error = "Please lonin before you start the game"
    erb :login
  else
    startup
    erb :game
  end
end

post '/game/player/hit' do
  session[:player].add_card(session[:deck].deal_one)
  erb :game
end

post '/game/player/stay' do
  erb :game
end

helpers do
  def test
    
  end

end
