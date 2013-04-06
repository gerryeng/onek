class SyncController < ApplicationController
	before_filter :load_session

	def sync
		# Read Game state

		# If no user is specified, create a new user session
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
			@player = Player.find(params[:uid])
			@game = @player.game
		else
			@player = Player.create
			@player.update_attribute('name', Faker::Name.name)

			# Find a game that is available
			@game = Game.find_available_game_or_create(@player)
			
		end
	end
end