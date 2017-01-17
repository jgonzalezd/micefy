class Slide < ActiveRecord::Base

  belongs_to :conference, inverse_of: :slides
  mount_uploader :picture, PictureUploader

  validate :number, :code, :conference, presence: true

  before_validation :set_code

  def set_code
    self.code = Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now.to_s}") if self.code.blank?
  end

  def storage_url
    "http://trendingconf.s3.amazonaws.com/" + picture.path
  end
end

# == Schema Information
#
# Table name: slides
#
#  id            :integer          not null, primary key
#  number        :integer
#  code          :string(255)
#  picture       :string(255)
#  conference_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
