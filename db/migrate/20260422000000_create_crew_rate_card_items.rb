class CreateCrewRateCardItems < ActiveRecord::Migration[8.1]
  def change
    create_table :crew_rate_card_items do |t|
      t.references :crew, null: false, foreign_key: true
      t.references :rate_card_item, null: false, foreign_key: true

      t.timestamps
    end

    add_index :crew_rate_card_items, [ :crew_id, :rate_card_item_id ], unique: true
  end
end
