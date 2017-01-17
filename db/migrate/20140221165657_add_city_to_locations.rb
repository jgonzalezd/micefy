class AddCityToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :city, index: true
  end
end
