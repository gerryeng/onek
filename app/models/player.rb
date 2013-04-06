class Player < ActiveRecord::Base
  attr_accessible :game_id, :name

  has_many :hard_cards
  has_many :table_cards

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
  	hand_cards.split(",")
  end

  def table_cards_array
  	table_cards.split(",")
  end
end
