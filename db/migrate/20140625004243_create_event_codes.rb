class CreateEventCodes < ActiveRecord::Migration
  def change
    create_table :event_codes do |t|
      t.string :status
      t.string :token

      t.timestamps
    end
  end
end
