class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :content, null: false
      t.references :user, foreign_key: true
      t.integer :post_comments_count
      t.integer :favorites_count

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
