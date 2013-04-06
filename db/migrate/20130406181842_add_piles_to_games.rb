class AddPilesToGames < ActiveRecord::Migration
  def change
    add_column :games, :deck_pile, :text
    add_column :games, :discard_pile, :text
  end
end
