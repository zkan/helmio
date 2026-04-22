class CreateCrewSites < ActiveRecord::Migration[8.1]
  def change
    create_table :crew_sites do |t|
      t.references :crew, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end

    add_index :crew_sites, [ :crew_id, :site_id ], unique: true
  end
end
