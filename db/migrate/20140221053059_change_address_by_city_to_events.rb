class ChangeAddressByCityToEvents < ActiveRecord::Migration
  def change
  	remove_column :events, :address, :city
  	add_reference :events, :city, index: true
  end
end
