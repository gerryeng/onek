class Player < ActiveRecord::Base
  attr_accessible :game_id, :name

  belongs_to :game

  def hash
    info "Player Hash for #{id}"
    reload
  	{
  		user_id: id,
  		name: name,
  		hand_cards: hand_cards_array,
  		table_cards: table_cards_array
  	}
  end

  def is_player_turn?
    game.turn == id
  end
  ###############
  # Discard/Destroy Cards
  ###############

  def discard_random_cards(quantity)
    # Discard cards from hand
    info "Discarding #{quantity} cards from hand"
    ids = hand_card_ids
    ids.pop(quantity)
    update_hand_cards(ids)
    info "Hand cards after discarding: #{hand_card_ids.join(',')}"
  end

  def destroy_random_cards(quantity)
      # Discard cards from table
    info "Discarding #{quantity} cards from table"
    ids = table_card_ids
    ids.pop(quantity)
    update_table_cards(ids)
    info "Table cards after discarding: #{table_card_ids.join(',')}"
  end


  ###############
  # Status
  ###############
  def is_end_of_turn?
    hand_cards_ids <= 5
  end

  ###############
  # Hand Cards
  ###############

  def hand_cards_array
    Card.cards_to_array(hand_card_objects)
  end

  def hand_card_ids
    info "Hand Cards: #{hand_cards.inspect}"
    if self.hand_cards.nil?
      info "Setting hand_cards to '' because it is nil"
      update_attribute('hand_cards', '')
    end
    hand_cards.split(",").map { |id| id.to_i }
  end

  def hand_card_objects
    Card.where(id: hand_card_ids)
  end

  def update_hand_cards(card_ids = [])
    info "Updating hand cards: #{card_ids.join(",")}"
    update_attribute('hand_cards', card_ids.join(','))
    reload
    info "Hand cards afer update #{hand_cards.split(",")}"
  end

  ###############
  # Table Cards
  ###############

  def table_cards_array
    Card.cards_to_array(table_card_objects)
  end

  def table_card_ids
    info "Table Cards: #{table_cards.inspect}"
  
    if self.table_cards.nil?
      info "Setting table_cards to '' because it is nil"
    update_attribute('table_cards', '')
    end
    table_cards.split(",").map { |id| id.to_i }
  end

  def table_card_objects
    Card.where(id: table_card_ids)
  end

  def is_card_in_hand?(card_id)
    hand_card_ids.include? card_id.to_i
  end

  def update_table_cards(card_ids = [])
    info "Updating table cards: #{card_ids.join(",")}"
    update_attribute('table_cards', card_ids.join(','))
    reload
  end

  ###############
  # Card Operations
  ###############

  def add_card_to_table(card_id)
    info "Adding card to table: #{card_id}"
    ids = table_card_ids
    ids << card_id
    update_table_cards(ids)
  end

  def remove_card_from_hand(card_id)
    ids = hand_card_ids
    ids.delete(card_id)
    update_hand_cards(ids)
  end

  def add_cards_to_hand(card_ids)
    info "Adding Cards to hand: #{card_ids.join(',')}"
    ids = hand_card_ids + card_ids
    info "After adding: #{ids.join(',')}"
    update_hand_cards(ids)
  end

  def place_card_on_table_from_hand(card_id)
    card_id = card_id.to_i
    # Remove card from hand
    remove_card_from_hand(card_id)

    # Add card to table
    add_card_to_table(card_id)
  end

  def draw_cards(number_of_cards)
    # Get cards from the deck pile for the user
    card_ids = game.draw_cards(number_of_cards)
    info "Drawing cards for player: #{id}"
    info "Cards drawn: #{card_ids.join(",")}"
    add_cards_to_hand(card_ids)
    card_ids
  end

  def info(msg)
    Rails.logger.info msg
  end

  def to_s
    name
  end
end