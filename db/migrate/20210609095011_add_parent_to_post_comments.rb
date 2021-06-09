class AddParentToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :post_comments, :parent, foreign_key: { to_table: :comments }
  end
end
