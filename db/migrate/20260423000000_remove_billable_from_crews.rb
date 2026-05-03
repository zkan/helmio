class RemoveBillableFromCrews < ActiveRecord::Migration[8.1]
  def change
    remove_column :crews, :billable
  end
end
