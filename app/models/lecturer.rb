class Lecturer < ActiveRecord::Base
  include LecturerConcern

  belongs_to :country
  has_and_belongs_to_many :conferences

  before_validation :smart_add_url_protocol

  attr_accessor :country_code

  validate :name, :country_id, presence: true
  validate :linkedin_url, presence: false
  validates_format_of :linkedin_url, :with => URI.regexp



  #validates :linkedin_url, :format => { :with => /\A((http|https):\/\/)?[a-z0-9]+([-.]{1}[a-z0-9]+).[a-z]{2,5}(:[0-9]{1,5})?(\/.)?\z/ix, :message => " is not valid" }
  #
  # Use this question for proper validation: http://stackoverflow.com/questions/7908598/add-https-to-url-if-its-not-there

  protected
	def smart_add_url_protocol
	  unless self.linkedin_url.nil? || self.linkedin_url[/\Ahttp:\/\//] || self.linkedin_url[/\Ahttps:\/\//]
	    self.linkedin_url = "http://#{self.linkedin_url}"
	  end
	end



end

# == Schema Information
#
# Table name: lecturers
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  linkedin_url :string(255)
#  country_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#
