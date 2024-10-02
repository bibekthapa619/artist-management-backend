class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :phone
      t.date :dob
      t.integer :gender
      t.integer :role, null: false 
      t.text :address
      t.references :super_admin, foreign_key: { to_table: :users, on_delete: :cascade }
      t.timestamps
    end
  end
end
