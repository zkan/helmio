class RenameIsActiveToActiveInSites < ActiveRecord::Migration[8.1]
  def change
    rename_column :sites, :is_active, :active
  end
end
