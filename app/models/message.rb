class Message < ActiveRecord::Base
  attr_accessible :message

  belongs_to :game

  def hash
  	{
  		timestamp: created_at.to_i,
  		message: message
  	}
  end
end