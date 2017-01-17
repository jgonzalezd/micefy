class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :country
      t.string :name, null: false
      t.column :longitude, :decimal, precision: 10, scale: 6
      t.column :latitude, :decimal, precision: 9, scale: 6
      t.string :region
    end
  end
end