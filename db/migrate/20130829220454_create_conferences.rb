class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.references :event, index: true
      t.references :location, index: true
      t.timestamps
    end
  end
end
