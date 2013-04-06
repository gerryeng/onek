class PlayController < ApplicationController

	before_filter :load_player
	before_filter :load_card

	def play_card
		if @card.is_thing?
			# Place the card on the table
			@player.place_card_on_table_from_hand(@card.id)
			# Apply card effect
			render json: {status: 'SUCCESS'}
		else
			render json: {ok: 'is action'}
		end
	end

	private

	def load_player
		@player = Player.where(id: params[:user_id]).first

		unless @player
			failed 'Invalid user_id'
			return
		end

		unless @player.is_player_turn?
			failed "Not this player's turn"
			return
		end

		@game = @player.game

	end

	def load_card
		@card = Card.where(id: params[:card_id]).first

		unless @card
			failed 'Invalid card_id'
			return
		end

		unless @player.is_card_in_hand?(@card.id)
			failed 'Card is not in hand, unable to play'
			return
		end
	end

end