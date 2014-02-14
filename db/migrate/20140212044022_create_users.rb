class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :administration
      t.string :salt
      t.string :hashed_password
      t.string :name
      t.boolean :gender
      t.string :class_name
      t.string :email
      t.integer :renren
      t.integer :qq
      t.integer :mobile

      t.timestamps
    end
  end
end
