class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :Bing_search
      t.string :title
      t.string :description
      t.string :url


      t.timestamps null: false
    end
  end
end
