class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :content, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :post_comments_count, null: false, default: 0
      t.integer :favorites_count, null: false, default: 0
      t.integer :reposts_count, null: false, default: 0

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
