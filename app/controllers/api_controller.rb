class ApiController < ApplicationController

	def sync
		sync_json = {
			'players' => {
				'status' => '123'
			}
		}
		render :json => sync_json	
	end

end