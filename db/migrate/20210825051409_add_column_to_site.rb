class AddColumnToSite < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :description, :text
  end
end
