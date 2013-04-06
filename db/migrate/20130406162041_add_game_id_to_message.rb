class AddGameIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :game_id, :integer
  end
end
