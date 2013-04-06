class RemoveStateFromGames < ActiveRecord::Migration
	def change
		remove_column :games, :state
	end
end
