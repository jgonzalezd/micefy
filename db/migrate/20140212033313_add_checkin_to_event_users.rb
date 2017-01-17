class AddCheckinToEventUsers < ActiveRecord::Migration
  def change
    add_column :event_users, :checkin, :boolean
  end
end
