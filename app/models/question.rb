class Question < ActiveRecord::Base
  belongs_to :conference
  belongs_to :user

  validates :content, presence: true

  acts_as_voteable
end

# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  content       :text
#  conference_id :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

