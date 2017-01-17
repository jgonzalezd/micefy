class Location < ActiveRecord::Base

  belongs_to :event
  belongs_to :city
  has_many :conferences

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  validates :name, presence: true, uniqueness: {scope: :event_id}
  validates :address, presence: true
  validates_length_of :name, minimum: 5, too_long: 255
end

# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  city_id    :integer
#  latitude   :float(24)
#  longitude  :float(24)
#  event_id   :integer
#
