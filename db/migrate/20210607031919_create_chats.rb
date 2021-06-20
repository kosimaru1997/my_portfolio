class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false
      t.string :message, null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
    add_index :chats, [:user_id, :room_id], unique: true
  end
end
