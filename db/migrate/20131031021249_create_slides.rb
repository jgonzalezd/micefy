class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :number
      t.string :code
      t.string :picture
      t.references :conference, index: true

      t.timestamps
    end
  end
end
