# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string(255)      not null
#  longitude  :decimal(10, 6)
#  latitude   :decimal(9, 6)
#  region     :string(255)
#

class City < ActiveRecord::Base
	belongs_to :country
	has_many :locations
end
