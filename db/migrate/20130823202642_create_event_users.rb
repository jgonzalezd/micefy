class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users, {:id => false} do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.string :rsvp
      t.boolean :invited

      t.timestamps
    end
    execute "ALTER TABLE event_users ADD PRIMARY KEY (event_id,user_id);"
  end
end
