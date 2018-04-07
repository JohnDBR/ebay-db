class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :product_id
      t.float :bid

      t.timestamps
    end
  end
end
