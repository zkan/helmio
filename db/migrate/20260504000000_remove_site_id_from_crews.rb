class RemoveSiteIdFromCrews < ActiveRecord::Migration[8.1]
  def change
    remove_column :crews, :site_id
  end
end
