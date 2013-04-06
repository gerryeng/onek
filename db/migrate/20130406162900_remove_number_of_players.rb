class RemoveNumberOfPlayers < ActiveRecord::Migration
	def change
		remove_column :games, :number_of_players
	end
end
