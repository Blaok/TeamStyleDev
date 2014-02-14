class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :information
      t.string :category

      t.timestamps
    end
  end
end
