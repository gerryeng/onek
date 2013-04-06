class SyncController < ApplicationController
	before_filter :load_session

	def sync
		info "Returning info hash"
		sync_json = {
			game_id: @game.id,
			players: @game.players_hash,
			whos_s_turn: @game.turn,
			user_id: @player.id,
			messages: @game.messages_hash,
			status: @game.status_hash
		}
		render json: sync_json
	end

	private

	def load_session
		if params[:uid]
			@player = Player.where(id: params[:uid]).first
			if @player
				@game = @player.game
			else
				failed 'Sending invalid player id'
			end
		else
			@player = Player.create
			@player.update_attribute('name', Faker::Name.name)

			# Find a game that is available
			@game = Game.find_available_game_or_create(@player)
		end
	end
end