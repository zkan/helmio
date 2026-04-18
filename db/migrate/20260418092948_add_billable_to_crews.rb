class AddBillableToCrews < ActiveRecord::Migration[8.1]
  def change
    add_column :crews, :billable, :boolean
  end
end
