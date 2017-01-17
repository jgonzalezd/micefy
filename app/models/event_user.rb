# == Schema Information
#
# Table name: event_users
#
#  event_id   :integer          default(0), not null
#  user_id    :integer          default(0), not null
#  rsvp       :string(255)
#  invited    :boolean
#  created_at :datetime
#  updated_at :datetime
#  checkin    :boolean
#  id         :integer          not null, primary key
#

class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
end
