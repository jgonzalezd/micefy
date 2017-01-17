class AddEventIdToEventCode < ActiveRecord::Migration
  def change
  	add_column :event_codes, :event_id, :integer
  end
end
