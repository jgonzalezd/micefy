class AddSecurityHashToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :security_hash, :string
  end
end
