class AddIdToEventUsers < ActiveRecord::Migration
  def change
    execute "ALTER TABLE event_users DROP PRIMARY KEY;"
    add_column :event_users, :id, :primary_key
  end
end
