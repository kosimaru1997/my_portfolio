class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :visitor, foreign_key: { to_table: :users }, null: false
      t.references :visited_id, foreign_key: { to_table: :users }, null: false
      t.integer :post_id, foreign_key: true
      t.integer :post_comment_id, foreign_key: true
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end

  end
end