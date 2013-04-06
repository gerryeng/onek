class Game < ActiveRecord::Base
  attr_accessible :number_of_players, :player_1, :player_2, :state
end
