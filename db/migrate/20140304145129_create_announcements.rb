class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.integer :sort_key
      t.string :content
      t.datetime :startat
      t.datetime :endat

      t.timestamps
    end
  end
end
