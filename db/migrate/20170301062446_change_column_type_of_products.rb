class ChangeColumnTypeOfProducts < ActiveRecord::Migration
  def change
  	change_column :products, :Bing_search, :text
  	change_column :products, :title, :text
  	change_column :products, :description, :text
  	change_column :products, :url, :text
  end
end
