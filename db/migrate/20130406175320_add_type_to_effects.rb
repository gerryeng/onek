class AddTypeToEffects < ActiveRecord::Migration
  def change
    add_column :effects, :type, :string
    add_column :effects, :value, :string
  end
end
