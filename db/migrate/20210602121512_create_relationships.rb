class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :follower, foreign_key: { to_table: :users }, null: false
      t.references :followed, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
