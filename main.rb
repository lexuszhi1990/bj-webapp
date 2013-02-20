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
  session[:dealer] = Dealer.new
end

get '/game' do
  if session[:name].nil?
    @error = "Please lonin before you start the game"
    erb :login
  else
    startup
    redirect '/game/player'
  end
end

get '/game/compare' do 
  p = session[:player].total 
  d = session[:dealer].total 
  if p > d
    @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points. congratulations, you win!"
  elsif p < d
    @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points.What a pity. you lost."
  else
    @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points. not so bad. It's a tie."
  end
    
  @stat = "end"
  erb :game
end

get '/game/restart' do
  session[:deck] = Deck.new
  session[:player].clear_cards
  session[:dealer].clear_cards
  redirect '/game/player'
end

get '/game/player' do

    session[:player].add_card(session[:deck].deal_one)
    session[:dealer].add_card(session[:deck].deal_one)
    session[:player].add_card(session[:deck].deal_one)
    session[:dealer].add_card(session[:deck].deal_one)

    if session[:dealer].hit_blackjack?
      @flash = "#{session[:name]},You lost. Dealer hit the blackjack"
      @stat = "end"
      erb :game
    elsif session[:player].hit_blackjack?
      @flash = "#{session[:name]},You hit the blackjack. Congratulations! You win!"
      @stat = "end"
      erb :game
    else
      @stat = "play"
      erb :game
    end
end

get '/game/dealer' do
  @flash = "now, it's dealer'turn. Click the button to dealer cards"
  @stat = "vacation"
  
  if session[:dealer].total > 17
    redirect "/game/compare"
  end

  erb :game
end

post '/game/dealer/hit' do
  session[:dealer].add_card(session[:deck].deal_one)
  total = session[:dealer].total
  if total == 21
    @flash = "#{session[:name]}.You lost. Dealer hit the blackjack"
    @stat = "end"
  elsif total > 21
    @flash = "#{session[:name]}. Dealer busted. Congratulation! You Win!"
    @stat = "end"
  elsif total < 17
    @flash = "go ahead"
    @stat = "vacation"
  end
  if total >= 17 && total < 21
    redirect "/game/compare"
  end

  erb :game
 
end

post '/game/player/hit' do
  session[:player].add_card(session[:deck].deal_one)
  if session[:player].is_busted?
    @flash = "Oh, Sorry! Your points is #{session[:player].total}.and you bursted..."
    @stat = "end"
  elsif session[:player].hit_blackjack?
    @flash = "#{session[:name]},you hit the blackjack. congratulations, you win!"
    @stat = "end"
  else
    @stat = "play"
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
