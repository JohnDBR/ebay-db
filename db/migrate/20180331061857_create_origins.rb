class CreateOrigins < ActiveRecord::Migration[5.1]
  def change
    create_table :origins do |t|
      t.string :country
      t.string :state
      t.string :city
      t.integer :postal_code
      t.string :address
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
