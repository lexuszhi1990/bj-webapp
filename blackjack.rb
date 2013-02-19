require "rubygems"
require "pry"
class Card
  attr_reader :suit, :face_value
  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end
  
  def find_suit
    ret = case @suit
          when 'H' then "hearts"
          when 'D' then "diamonds"
          when 'S' then "spades"
          when 'C' then "clubs"
          end 
    ret
  end

  def load_path
    val = case @face_value
          when 'J' then "jack"
          when 'Q' then "queen"
          when 'K' then "king"
          when 'A' then "ace"
          else @face_value.to_s
          end
      "/images/cards/" + find_suit + "_" + val + ".jpg"
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
    total > 21
  end

  def hit_blackjack?
    total == 21
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
  
end

#binding.pry
