class ApplicationController < ActionController::Base
  protect_from_forgery

  
	def failed(msg)
		render json: { status: 'FAILED', message: msg } and return
	end

	def info(msg)
		Rails.logger.info msg
	end
end
