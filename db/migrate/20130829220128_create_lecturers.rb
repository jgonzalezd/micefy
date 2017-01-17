class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :name
      t.text :description
      t.string :linkedin_url
      t.references :country, index: true

      t.timestamps
    end
  end
end
