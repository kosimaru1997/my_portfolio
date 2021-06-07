class CreateUserRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :user_rooms do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
    add_index :user_rooms, :user_id
    add_index :user_rooms, :room_id
    add_index :user_rooms, [:user_id, :room_id], unique: true
  end
end
