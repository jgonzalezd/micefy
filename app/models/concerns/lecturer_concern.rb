module LecturerConcern
  extend ActiveSupport::Concern

  included do
    before_create :setup_country_id
    before_update :setup_country_id
  end

  def setup_country_id
    _country = Country.find_by code: country_code
    self.country_id = _country.id unless _country.nil?
  end

end
