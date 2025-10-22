class RemoveStringFromCategories < ActiveRecord::Migration[8.0]
  def change
    remove_column :categories, :string, :string
  end
end
