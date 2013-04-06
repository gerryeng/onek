class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :number_of_players
      t.integer :player_1
      t.integer :player_2
      t.text :state

      t.timestamps
    end
  end
end
