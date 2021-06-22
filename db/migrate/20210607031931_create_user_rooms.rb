class CreateUserRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rooms do |t|
      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false

      t.timestamps
    end
    add_index :user_rooms, [:user_id, :room_id], unique: true
  end
end
