class AddTypes < ActiveRecord::Migration
	def change
		add_column :effects, :effect_type, :string
		add_column :cards, :card_type, :string
	end
end
