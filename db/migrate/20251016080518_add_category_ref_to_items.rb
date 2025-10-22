class AddCategoryRefToItems < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :category, null: false, foreign_key: true
  end
end
