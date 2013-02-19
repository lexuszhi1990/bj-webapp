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

    session[:player].add_card(session[:deck].deal_one)
    session[:dealer].add_card(session[:deck].deal_one)
    session[:player].add_card(session[:deck].deal_one)
    session[:dealer].add_card(session[:deck].deal_one)

    if session[:dealer].hit_blackjack?
      @stat = "lose"
      @flash = "dealer hit the Blackjack"
      erb :game
    elsif session[:player].hit_blackjack?
      @stat = "win"
      @flash = "you hit the Blackjack"
      erb :game
    else
      redirect '/game/player'
    end
  end
end

get '/game/compare' do 
  if session[:player].total > session[:dealer].total
    @flash = "#{session[:name]}, congratulations, you win!"
    @stat = "win"
  elsif session[:player].total < session[:dealer].total
    @flash = "#{session[:name]}, sorry, your lost"
    @stat = "lose"
  else
    @flash = "It a tie"
    @stat = "tie"
  end

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
  @flash = "now, it's dealer'turn, click the git button to dealer cards"
  @stat = "vacation"
  
  if session[:dealer].total > 17
    redirect "/game/compare"
  end

  erb :game
end

post '/game/dealer/hit' do
  @flash = "once again"
  @stat = "vacation"
  total = session[:dealer].total
  if total > 17 && total < 21
    redirect "/game/compare"
  elsif total == 21
    @flash = "dealer hit the Blackjack"
    @stat = "lose"
  elsif total > 21
    @flash = "dealer busted"
    @stat = "win"
  elsif total < 17
      session[:dealer].add_card(session[:deck].deal_one)
  end

  erb :game
 
end

post '/game/player/hit' do
  session[:player].add_card(session[:deck].deal_one)
  if session[:player].is_busted?
    @flash = "Oh, Sorry! You bursted..."
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
