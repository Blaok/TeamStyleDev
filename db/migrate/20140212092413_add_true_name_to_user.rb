class AddTrueNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :true_name, :string
  end
end
