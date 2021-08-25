class ChangeDataNoteToSite < ActiveRecord::Migration[5.2]
  def change
    change_column :sites, :note, :text
  end
end
