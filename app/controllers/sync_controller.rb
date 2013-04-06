class SyncController < ApplicationController
	before_filter :load_session

	def sync_dummy
		sync_json = {
			players: 'a',
			whos_s_turn: 'a',
			user_id: 'a',
			messages: 'a',
			status: 'a'
		}
		render json: sync_json
	end

	def sync
		# Read Game state

		# If no user is specified, create a new user session

		sync_json = {
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
		if params[:user_id]
			@player = Player.find(params[:user_id])
			@game = @player.game
		else
			@player = Player.new name: "Player #{Random.rand.to_i}"

			# Find a game that is available
			@game = nil
			Game.all.each do |g|
				if g.players.count < 2
					@game = g
					break
				end
			end

			if @game.nil?
				@game = Game.create 
			end

			@player.game_id = @game.id
		end
	end
end