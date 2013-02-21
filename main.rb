require 'rubygems'
require 'sinatra'
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
  session[:deck] = nil
  session[:player] = nil
  session[:dealer] = nil
  session[:gold] = nil
  session[:bet] = nil
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
  session[:deck] = Deck.new
  session[:player] = Player.new(session[:name])
  session[:dealer] = Dealer.new
  session[:gold] = 500
  session[:bet] = 0
end

before '/game/*' do
  if session[:name].nil?
    @error = "Please login before you start the game"
    redirect '/login'
  end
end

get '/game' do
    startup
    redirect '/game/bet'
end

get '/game/bet' do

end

get '/game/compare' do 
  p = session[:player].total 
  d = session[:dealer].total 
  if p == 21
    @flash = "#{session[:name]},You lost. Dealer hit the blackjack"
  elsif p > 21
    @flash = "Oh, Sorry! Your points is #{session[:player].total}.and you bursted..."
  elsif d == 21
    @flash = "#{session[:name]},You hit the blackjack. Congratulations! You win!"
  elsif d > 21
    @flash = "#{session[:name]}. Dealer busted. Congratulation! You Win!"
  else
    case p <=> d
    when 1 then 
      @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points. congratulations, you win!"
    when -1 then
      @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points.What a pity. you lost."
    when 0 then
      @flash = "#{session[:name]},your points :#{p} vs #{d} Dealer's points. Not so bad. It's a tie."
    end
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

  2.times do
    session[:player].add_card(session[:deck].deal_one)
    session[:dealer].add_card(session[:deck].deal_one)
  end

  if session[:dealer].hit_blackjack? || session[:player].hit_blackjack?
    redirect "/game/compare"
  else
    @stat = "play"
    erb :game
  end
end

post '/game/player/hit' do
  if wrong_bet_amount?
    @error = "Wrong bet amount.The bet should between 5 and 100!"
    @stat = "play"
    erb :game
  else
    session[:player].add_card(session[:deck].deal_one)
    session[:gold] = session[:gold] - params[:bet_amount].to_i
    session[:bet] = params[:bet_amount].to_i
    if session[:player].is_busted? || session[:player].hit_blackjack?
      redirect "/game/compare"
    else
      @stat = "play"
    end
    erb :game
  end
end

post '/game/player/stay' do
  redirect '/game/dealer'
end

get '/game/dealer' do
  @flash = "now, it's dealer'turn. Click the button to dealer cards"
  @stat = "vacation"
  if session[:dealer].total >= 17
    redirect "/game/compare"
  end

  erb :game
end

post '/game/dealer/hit' do
  session[:dealer].add_card(session[:deck].deal_one)
  total = session[:dealer].total
  if total < 17
    @flash = "go ahead"
    @stat = "vacation"
  else
    redirect "/game/compare"
  end

  erb :game

end

helpers do
  def test

  end

  def picture_path(card)

    #"/images/cards/hearts_2.jpg"
    #"/images/cards/" + card.suit.downcase + 
  end

  def wrong_bet_amount?
    if params[:bet_amount].empty? || params[:bet_amount].to_i < 5 || params[:bet_amount].to_i > 100
      true
    else
      false
    end
  end
end
