class SyncController < ApplicationController
	before_filter :load_session


	def sync
		# Read Game state

		# If no user is specified, create a new user session

		sync_json = {
			'players' => {
				status:  @game.status,
				who_s_turn: @game.who_s_turn,
				user_id: @user_id,
				messages: @game.messages
			}
		}
		render json: sync_json
	end

	private

	def load_session
		if params[:user_id]
			@user_id = params[:user_id]
			@game = GameSession.where('player_1 = ? or player_2 = ?', @user_id, @user_id)
		else
			Random.rand()
		end
	end

end