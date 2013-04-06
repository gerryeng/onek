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
  	hand_cards.split(",")
  end

  def table_cards_array
    update_attribute('table_cards', '') if table_cards.nil?
  	table_cards.split(",")
  end
end