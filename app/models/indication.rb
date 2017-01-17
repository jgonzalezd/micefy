# == Schema Information
#
# Table name: indications
#
#  id         :integer          not null, primary key
#  content    :text
#  kind       :string(255)
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Indication < ActiveRecord::Base
	# TODO: Validate indications kind.
	validates :kind, inclusion: { in: %w(information warning regulatory), message: "%{value} is not a valid kind for an indication." }
end
