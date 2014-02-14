class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :name
      t.text :information
      t.string :path
      t.string :category
      t.integer :course_id

      t.timestamps
    end
  end
end
