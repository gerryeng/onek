class Player < ActiveRecord::Base
  attr_accessible :game_id, :name

  belongs_to :game

  def hash
  	{
  		user_id: id,
  		name: name,
  		hand_cards: hand_cards_array,
  		table_cards: table_cards_array
  	}
  end

  def hand_cards_array
    update_attribute('hand_cards', '') if hand_cards.nil?
  	cards = Card.where(id: hand_cards.split(","))
    card_array = []
    cards.each do |card|
      card_array << card.hash
    end

    card_array
  end

  def table_cards_array
    update_attribute('table_cards', '') if table_cards.nil?
  	table_cards.split(",")
  end

  def draw_cards(number_of_cards)
    # Get cards from the deck pile for the user
    cards = game.draw_cards(number_of_cards)
    update_attribute('hand_cards', cards.join(','))

    cards
  end
end