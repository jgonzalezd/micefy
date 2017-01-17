class CreateIndications < ActiveRecord::Migration
  def change
    create_table :indications do |t|
      t.text :content
      t.string :kind
      t.references :event, index: true

      t.timestamps
    end
  end
end
