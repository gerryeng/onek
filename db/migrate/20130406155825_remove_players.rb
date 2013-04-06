class RemovePlayers < ActiveRecord::Migration
	def change
		remove_column :games, :player_1
		remove_column :games, :player_2
	end
end
