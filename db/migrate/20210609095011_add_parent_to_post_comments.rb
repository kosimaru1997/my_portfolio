class AddParentToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :post_comments, :parent, foreign_key: { to_table: :post_comments }
    add_column :post_comments, :post_comments_count, :integer
  end
end

