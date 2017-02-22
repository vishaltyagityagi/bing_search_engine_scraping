class AddColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :search, :string
  end
end
