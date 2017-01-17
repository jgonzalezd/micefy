class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :country_code, limit: 2
      t.timestamps
    end
  end
end
