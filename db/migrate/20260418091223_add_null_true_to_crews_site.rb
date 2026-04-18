class AddNullTrueToCrewsSite < ActiveRecord::Migration[8.1]
  def change
    change_column_null :crews, :site_id, true
  end
end
