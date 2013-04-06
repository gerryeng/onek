class Remove < ActiveRecord::Migration
	def change
		remove_column :effects, :type
		remove_column :cards, :type
	end
end
