class AddCardsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :hand_cards, :string
    add_column :players, :table_cards, :string
  end
end
