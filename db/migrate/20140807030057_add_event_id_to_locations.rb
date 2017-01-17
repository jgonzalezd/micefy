class AddEventIdToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :event, index: true
  end
end
