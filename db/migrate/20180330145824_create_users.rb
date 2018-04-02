class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.boolean :company, default: false
      t.string :name
      t.string :username
      t.string :password_digest
      t.integer :role, default: 0
      t.string :email
      t.date :birthdate
      t.integer :gender, default: 0
      # t.integer :picture_id

      t.timestamps
    end
  end
end
