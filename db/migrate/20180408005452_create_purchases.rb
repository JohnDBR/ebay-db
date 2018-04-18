class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :seller, index: true, foreign_key: true
      t.references :buyer, index: true, foreign_key: true
      t.integer :origin_id, 
      t.integer :product_id
      t.integer :quantity, default: 1
      t.float :total_price
      t.integer :buyer_score
      t.integer :seller_score
      t.boolean :was_shipped, default: false
      t.boolean :was_delivered, default: false

      t.timestamps
    end
  end
end
