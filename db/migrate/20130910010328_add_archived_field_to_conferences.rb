class AddArchivedFieldToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :archived, :boolean
  end
end
