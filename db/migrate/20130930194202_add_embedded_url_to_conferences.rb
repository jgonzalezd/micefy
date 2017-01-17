class AddEmbeddedUrlToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :embedded_url, :string
  end
end
