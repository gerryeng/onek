class CardsEffects < ActiveRecord::Migration
	def change
		create_table :cards_effects do |t|
	      t.integer :card_id
	      t.integer :effect_id
    	end
	end

end
