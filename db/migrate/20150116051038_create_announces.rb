class CreateAnnounces < ActiveRecord::Migration
  def change
    create_table :announces do |t|
      t.text :content
      t.references :user, index: true
      t.references :event, index: true

      t.timestamps
    end
  end
end
