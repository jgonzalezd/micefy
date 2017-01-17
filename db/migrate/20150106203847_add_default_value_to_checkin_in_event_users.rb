class AddDefaultValueToCheckinInEventUsers < ActiveRecord::Migration
  def up
    change_column :event_users, :checkin, :boolean, default: false
    EventUser.where(checkin: nil).update_all(checkin: false)
  end

  def down
    change_column_null :event_users, :checkin, true
    change_column :event_users, :checkin, :boolean, default: nil
  end
end
