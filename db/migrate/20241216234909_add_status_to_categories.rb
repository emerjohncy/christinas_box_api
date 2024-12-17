class AddStatusToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :status, :string
  end
end
