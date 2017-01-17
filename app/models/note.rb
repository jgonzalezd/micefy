class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference

  validates :content, presence: true
end

# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  content       :text
#  user_id       :integer
#  conference_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
