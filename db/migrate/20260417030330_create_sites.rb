class CreateSites < ActiveRecord::Migration[8.1]
  def change
    create_table :sites do |t|
      t.string :name
      t.text :description
      t.string :company_name
      t.text :company_address
      t.string :company_tax_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
