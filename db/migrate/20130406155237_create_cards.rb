class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :type
      t.string :description
      t.string :image_url

      t.timestamps
    end
  end
end
