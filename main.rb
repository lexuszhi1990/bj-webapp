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
  @another = false
  session[:deck] = Deck.new
  session[:player] = Player.new(session[:name])
  session[:player].add_card(session[:deck].deal_one)
  session[:player].add_card(session[:deck].deal_one)

  session[:dealer] = Dealer.new
  session[:dealer].add_card(session[:deck].deal_one)
  session[:dealer].add_card(session[:deck].deal_one)
end

get '/game' do
  if session[:name].nil?
    @error = "Please lonin before you start the game"
    erb :login
  else
    startup

   if session[:dealer].hit_blackjack?

    end
    redirect '/game/player'
  end
end

get '/game/compare' do 
  if session[:player].total > 21

  end
  if session[:player].total > session[:dealer].total
    @flash = "#{session[:name]}, congratulations, you win!"
  elsif session[:player].total < session[:dealer].total
    @flash = "#{session[:name]}, sorry, your lost"
  else
    @flash = "It a tie"
  end

  @another = true
  erb :game

end

get '/game/result' do
    if person.name.eql?(session[:name])
      puts person.name
      if person.total == 21
        @flash = "#{session[:name]}, congratulations, you win!"
        @another = true
      elsif person.total > 21
        @flash = "#{session[:name]}, sorry, your burst!"
        @another = true
      end
    else
      if person.total == 21
        @flash = "#{session[:name]},you lost, dealer hit the blackjack"
        @another = true
      elsif person.total > 21
        @flash = "#{session[:name]},you win, lealer busted"
        @another = true
      end

    end

  end

get '/game/restart' do
  session[:player].clear_cards
  redirect '/game'
end

get '/game/player' do
  erb :game
end

get '/game/dealer' do
  @flash = "now, it's dealer'turn"
  total = session[:dealer].total
  while total < 17
      session[:dealer].add_card(session[:deck].deal_one)
      total = session[:dealer].total
    if total > 21
      
    end
  end

end

post '/game/player/hit' do
  session[:player].add_card(session[:deck].deal_one)
  if session[:player].is_busted?
    @another = "You bursted..."
    @stat = "bust"
  end
  erb :game
end

post '/game/player/stay' do
  redirect '/game/dealer'
end

helpers do
  def test
    
  end
 
  def picture_path(card)
    
      #"/images/cards/hearts_2.jpg"
      #"/images/cards/" + card.suit.downcase + 
  end
end
