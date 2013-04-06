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
  	h = []
  	messages.each do |m|
  		h << m.hash
  	end
  	h
  end


  ###############
  # Card Effects
  ###############

  def apply_card_effects(card_player, card)
    msg "#{card_player} played the #{card} card"
    card.effects.each do |effect|
      apply_effect(card_player, effect)
    end
  end

  def apply_effect(card_player, effect)
    if effect.effect_type == 'DISCARD'
      msg "#{card_player}: Card has a discard effect. Will discard one card from opponent's hand"
      discard_opponent_cards(card_player, 1)
    elsif effect.effect_type == 'DESTROY'
      msg "#{card_player}: Card has a destroy effect. Will destroy one card from opponent's table"
      destroy_opponent_cards(card_player, 1)
    end
  end

  def discard_opponent_cards(card_player, quantity)
    opponents_of(card_player).each do |opponent_player|
      opponent_player.discard_random_cards(quantity)
    end
  end

  def destroy_opponent_cards(card_player, quantity)
    opponents_of(card_player).each do |opponent_player|
      opponent_player.destroy_random_cards(quantity)
    end
  end

  def opponents_of(player)
    players.select { |p| p.id != player }
  end

  def draw_cards(number_of_cards)
    card_ids = deck_pile.split(",")
    cards_drawn = card_ids.pop(number_of_cards)
    update_attribute('deck_pile', card_ids.join(","))

    cards_drawn
  end
  ###############
  # Game setup
  ###############

  def self.setup_new_game(player)
    g = Game.create(status: 'AWAIT_JOIN', status_message: "{user_id: #{player.id}}")
    g.msg 'Waiting for another player to join'
    g.update_attribute('turn', player.id)
    g.update_attribute('deck_pile', Card.all.map(&:id).shuffle.join(","))
    g.update_attribute('discard_pile', "")
    g
  end

  def have_enough_players?
    players.count >= 2
  end

  def start_game
    # Let random player start the game
    player = players.sample
    update_attribute('status', 'AWAIT_PLAYER')
    update_attribute('status_message', "{user_id: #{player.id}}")
    update_attribute('turn', player.id)
    msg "#{player.name}\'s turn to play card\""
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

  def clear_messages
    messages.each do |message|
      message.destroy
    end
  end

  def msg(message)
    messages.create message: message
    info message
  end

  def info(message)
    Rails.logger.info message
  end
end
