class AddMapToEvents < ActiveRecord::Migration
  def change
    add_column :events, :map_picture, :string
  end
end
