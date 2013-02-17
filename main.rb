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
  params[:name]
  if !params[:name].empty?
    session[:name] = params[:name]
    redirect '/game'
  else
    @error = "Must input a name"
    erb :login
  end
end


get '/game' do
  @deck = Deck.new
  @dealer = Dealer.new
  @player = Player.new(session[:name])
  
  @game = Blackjack.new

  erb :game
end

