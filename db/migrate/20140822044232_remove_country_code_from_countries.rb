class RemoveCountryCodeFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :country_code, :string
  end
end
