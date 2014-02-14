class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.text :information
      t.integer :course_id
      t.datetime :startat
      t.datetime :deadline

      t.timestamps
    end
  end
end
