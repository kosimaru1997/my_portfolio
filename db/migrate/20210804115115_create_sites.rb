class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.references :user, foreign_key: true, null: false
      t.string :url, null: false
      t.string :title
      t.text :image_id
      t.string :note

      t.timestamps
    end
  end
end
