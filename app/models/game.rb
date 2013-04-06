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
  		type: status,
  		body: eval(status_message)
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
    g = Game.create(status: 'AWAIT_JOIN', status_message: "{message: 'Waiting for another player to join'}")
    g.update_attribute('turn', player.id)
    g.update_attribute('deck_pile', Card.all.map(&:id).shuffle.join(","))
    g.update_attribute('discard_pile', "")
    g
  end

  def draw_cards(number_of_cards)
    card_ids = deck_pile.split(",")
    cards_drawn = card_ids.pop(number_of_cards)
    update_attribute('deck_pile', card_ids.join(","))

    cards_drawn
  end

  def have_enough_players?
    players.count >= 2
  end

  def start_game
    # Let random player start the game
    player = players.sample
    update_attribute('status', 'AWAIT_PLAYER')
    update_attribute('status_message', "{user_id: #{player.id}, message: \"#{player.name}\'s turn to play card\"}")
    update_attribute('turn', player.id)
    Rails.logger.info "Starting game: #{id}"
  end

  def self.find_available_game_or_create(player)
    game = nil
    Game.all.each do |g|
      if g.players.count < 2
        game = g
        break
      end
    end

    if game.nil?
      game = Game.setup_new_game(player)
      player.update_attribute('game_id', game.id)
    else
      # Player have joined an existing game
      # If the game has enough players, set the status to start
      Rails.logger.info "Joined the game: #{game.id}"
      player.update_attribute('game_id', game.id)
      if game.have_enough_players?
        game.start_game
      end
    end
  
    # Draw 5 cards for the player
    player.draw_cards(5)
    
    game
  end
end
