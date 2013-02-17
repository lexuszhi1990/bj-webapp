class Card
  attr_reader :suit, :face_value
  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end
  
  def find_suit
    ret = case @suit
          when 'H' then "Hearts"
          when 'D' then "Diamonds"
          when 'S' then "Spades"
          when 'C' then "Clubs"
          end 
    ret
  end

  def pretty_output
    "The #{@face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    ['H', 'C', 'S', 'D'].each do |s|
      ['2', '3', '4', '5', '6', '7', '8','9',
                    '10', 'J', 'Q', 'K', 'A'].each do |fv|
          @cards << Card.new(s, fv)
      end
    end
    scramble!
  end

  def scramble!
    @cards.shuffle!
  end

  def size
    @cards.size
  end

  def deal_one
    @cards.pop
  end

  def to_s
    @cards.each do |card|
        card.pretty_output
    end
  end
end

module Hand

  def show_hand
    puts "---- #{@name}'s Hand ----"
    @cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end
  
  def total
    face_values = cards.map { |card|  card.face_value if !card.nil?}
    total = 0
    face_values.each do |fv|
        if fv == "A"
          total += 11
        else
          total += (fv.to_i == 0 ? 10 : fv.to_i)
        end
    end

    face_values.select { |val| val == 'A' }.count.times do 
      break if total <= 21
      total -= 10
    end
    
    total

  end
  
  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end

  def clear_cards
    cards.clear
  end

end


class Player
  include Hand
  attr_reader :name, :cards

  def initialize(name="ZHI")
      @name = name
      @cards = []
  end
  
end

class Dealer
  include Hand
  attr_reader :name, :cards

  def initialize(name="Dealer")
      @name = name
      @cards = []
  end

  def show_hand
    puts "---- #{@name}'s Hand ----"
    puts "The first card is hidden"
    @cards[1..-1].each do |card|
      puts "=> #{card}"
    end
  end
  
end

class Blackjack
  attr_reader :player, :dealer, :deck

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17


  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def getchoice
      s = gets.chomp
      while(s != "1" && s != "2")
          puts "please input the right choice, 1 or 2"
          s = gets.chomp
      end
      s
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations, you hit blackjack! #{player.name} win!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. #{player.name} win!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end
      play_again?
    end
  end

  def deal_cards
    @player.add_card(@deck.deal_one)
    @dealer.add_card(@deck.deal_one)
    @player.add_card(@deck.deal_one)
    @dealer.add_card(@deck.deal_one)
  end

  def show_flop
    @player.show_hand
    @dealer.show_hand
  end

  def player_turn
    puts "Now, it's player's turn..."

    while !@player.is_busted?
      puts "make a choice : 1> hit, 2> stay"
      res = getchoice
      if res == '2'
       puts "#{player.name} chose to stay."
        break
      end

      new_card = @deck.deal_one
      puts "Dealing card to #{@player.name}: #{new_card}"
      @player.add_card(new_card)
      puts "#{@player.name}'s total is now: #{player.total}"
      blackjack_or_bust?(@player)
    end
    puts "#{@player.name} stay at #{player.total}"
  end

  def dealer_turn
    puts "Now, it's dealer's turn..."

    while @dealer.total < DEALER_HIT_MIN
      new_card = @deck.deal_one
      puts "Dealing card to #{@dealer.name}: #{new_card}"
      @dealer.add_card(new_card)
      puts "#{@dealer.name}'s total is now: #{@dealer.total}"
      blackjack_or_bust?(@dealer)
    end
    puts "#{@dealer.name} stay at #{dealer.total}"
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) yes 2) no, exit"
    res = getchoice
    if res == '1'
      puts "Starting new game..."
      puts ""
      deck = Deck.new
      player.clear_cards
      dealer.clear_cards
      start
    else
      puts "Goodbye!"
      exit
    end 
  end

  def start
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end


class Game < Blackjack

end
