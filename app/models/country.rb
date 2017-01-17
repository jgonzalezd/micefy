class Country < ActiveRecord::Base
  has_many :lecturers
  has_many :cities

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end

# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  code       :string(255)
#
