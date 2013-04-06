class ApiController < ApplicationController

	def sync
		# Read Game state
		sync_json = {
			'players' => {
				status:  '123',
				who_s_turn: 123,
				user_id: '123'
			}
		}
		render json: sync_json
	end

end