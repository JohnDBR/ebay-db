class CreateProductPictures < ActiveRecord::Migration[5.1]
  def change
    create_table :product_pictures do |t|
      t.integer :picture_id
      t.integer :product_id

      t.timestamps
    end
  end
end
