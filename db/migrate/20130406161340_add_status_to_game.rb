class AddStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :status, :string
    add_column :games, :status_message, :string
  end
end
