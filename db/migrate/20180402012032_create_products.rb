class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :category
      t.string :shipping_description
      t.integer :origin_id
      t.integer :user_id
      t.integer :stock, default: 1
      t.float :price
      t.boolean :is_used, default: false
      t.integer :picture_id

      t.timestamps
    end
  end
end