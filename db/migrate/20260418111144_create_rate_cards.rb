class CreateRateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :rate_cards do |t|
      t.string :name
      t.references :site, null: false, foreign_key: true
      t.date :effective_from
      t.date :effective_to

      t.timestamps
    end
  end
end
