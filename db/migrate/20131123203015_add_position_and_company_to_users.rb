class AddPositionAndCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :position, :string
    add_column :users, :company, :string
  end
end
