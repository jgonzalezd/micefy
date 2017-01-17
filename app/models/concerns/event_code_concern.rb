module EventCodeConcern
  extend ActiveSupport::Concern

  included do
    after_initialize :setup_token
  end

  def setup_token
    self.token = SecureRandom.hex(12) if new_record?
  end

end
