class AddAssignmentIdToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :assignment_id, :integer
  end
end
