class CreateMusics < ActiveRecord::Migration[7.1]
  def change
    create_table :musics do |t|
      t.references :artist, null: false, foreign_key: { on_delete: :cascade }
      t.string :title, null: false
      t.string :album_name, null: false
      t.integer :genre, null: false
      t.timestamps
    end
  end
end
