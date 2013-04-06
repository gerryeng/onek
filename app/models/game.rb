class Game < ActiveRecord::Base
  attr_accessible :number_of_players, :player_1, :player_2, :state, :turn, :status, :status_message

  has_many :players
  has_many :messages

  def players_hash
  	h = []
  	players.each do |p|
  		h << p.hash
  	end

  	h
  end

  def status_hash
  	{
  		status: status,
  		body: status_message
  	}
  end

  def messages_hash
  	h = {}
  	messages.each do |m|
  		h << m.hash
  	end
  	h
  end

  def self.setup_new_game(player)
    g = Game.create(status: 'AWAIT_PLAYER', status_message: 'Waiting for another player to join')
    g.update_attribute('turn', player.id)
    g
  end

  def self.find_available_game_or_create(player)
    game = nil
    Game.all.each do |g|
      if g.players.count < 2
        game = g
      end
    end

    if game.nil?
      game = Game.setup_new_game(player)
    end

    # Assign player to game
    player.update_attribute('game_id', game.id)
    
    game
  end
end
