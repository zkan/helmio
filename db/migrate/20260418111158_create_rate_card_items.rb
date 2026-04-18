class CreateRateCardItems < ActiveRecord::Migration[8.1]
  def change
    create_table :rate_card_items do |t|
      t.references :rate_card, null: false, foreign_key: true
      t.string :role
      t.string :unit
      t.decimal :price
      t.string :currency

      t.timestamps
    end
  end
end
