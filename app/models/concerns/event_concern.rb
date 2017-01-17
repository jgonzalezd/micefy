module EventConcern
  extend ActiveSupport::Concern

  included do
    before_create :setup
  end

  def setup
    self.token = SecureRandom.hex(12)
  end
end
