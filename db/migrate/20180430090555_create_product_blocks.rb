class CreateProductBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :product_blocks do |t|
      t.integer :product_id
      t.integer :blocked_stock, default: 0
     
      t.timestamps
    end
  end
end
