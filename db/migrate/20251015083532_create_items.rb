class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.decimal :tax_rate
      t.boolean :available

      t.timestamps
    end
  end
end
