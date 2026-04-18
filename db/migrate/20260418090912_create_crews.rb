class CreateCrews < ActiveRecord::Migration[8.1]
  def change
    create_table :crews do |t|
      t.string :name
      t.string :name_th
      t.string :nickname
      t.string :email
      t.string :phone
      t.decimal :man_day_rate
      t.date :joined_date
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
