class Game < ActiveRecord::Base
  attr_accessible :number_of_players, :player_1, :player_2, :state

  has_many :players
  has_many :messages

  def players_hash
  	h = {}
  	players.each do |p|
  		h << p.hash
  	end

  	h
  end

  def status_hash
  	{
  		status: status,
  		message: status_message
  	}
  end

  def messages_hash
  	h = {}
  	messages.each do |m|
  		h << m.hash
  	end

  	h
  end
end
