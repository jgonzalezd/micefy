class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.references :user, index: true
      t.references :conference, index: true

      t.timestamps
    end
  end
end
