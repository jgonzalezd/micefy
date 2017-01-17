# == Schema Information
#
# Table name: event_codes
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EventCode < ActiveRecord::Base
  include AASM
  include EventCodeConcern

  validates :status, :token, presence: true

  aasm :column => 'status' do
    state :active, :initial => true
    state :inactive

    event :deactivate do
      transitions :from => :active, :to => :inactive
    end

    event :activate do
      transitions :from => :inactive, :to => :active
    end
  end

  def status_enum
    [:active, :inactive]
  end

  class << self
    def active
      where(status: :active)
    end
    def active
      where(status: :inactive)
    end
  end
end
