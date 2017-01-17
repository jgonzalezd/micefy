# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  start_at     :datetime
#  end_at       :datetime
#  organizer_id :integer
#  logo         :string(255)
#  map_picture  :string(255)
#  city_id      :integer
#  status       :string(255)
#  token        :string(255)
#  timezone     :string(255)
#

class Event < ActiveRecord::Base
  include AASM
  include EventConcern
  belongs_to :organizer
  belongs_to :city

  has_many :event_users, dependent: :destroy
  has_many :conferences, dependent: :destroy
  has_many :indications, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :lecturers, through: :conferences # exclude from rails admin forms
  has_many :announces, dependent: :destroy
  has_many :attendees, -> { where(checkin: true) }, class_name: "EventUser"
  has_many :attendees_users, through: :attendees, class_name: "User", source: :user  # exclude from rails admin forms
  has_many :attending_users, through: :attendees, class_name: "User", source: :user
  accepts_nested_attributes_for :locations, allow_destroy: true
  accepts_nested_attributes_for :indications, allow_destroy: true, reject_if: proc { |attributes| attributes['content'].blank? }

  validates :name, presence: true
  validates :timezone, presence: true
  validates_length_of :description, maximum: 500, too_long: 500

  attr_accessor :set_location_to_all_confs

  acts_as_taggable rescue nil

  mount_uploader :logo, EventLogoUploader
  mount_uploader :map_picture, EventMapUploader

  aasm :column => 'status' do
    state :draft, :initial => true
    state :published

    event :publish do
      transitions :from => :draft, :to => :published, guard: :dates_already_set?
    end

    event :unpublish do
      transitions :from => :published, :to => :draft
    end
  end

  rails_admin do
    edit do
      exclude_fields :lecturers, :attendees, :attendees_users
    end
  end

  alias_method :attendants, :attendees

  def status_enum #TODO is this being used ever?
    [["Borrador", :draft], ["Publicado", :published]]
  end

  def dates_already_set?
    start_at.present? && end_at.present?
  end

  def attending
    event_users.where(rsvp: "yes")
  end

  def storage_url
    logo.present? ? "http://trendingconf.s3.amazonaws.com/" + logo.path : "images/logo_default.png"
  end

  def map_picture_url
    map_picture.present? ? "http://trendingconf.s3.amazonaws.com/" + map_picture.path : "images/logo_default.png"
  end

  def past?
    start_at.present? && start_at < Time.zone.now
  end

  def published?
    return true unless self.status != "published"
  end

  def in_time?(time = Time.zone.now)
    (start_at.blank? || end_at.blank?) ? false : (time >= start_at && time <= end_at)
  end

  def get_current_conferences
    now = Time.zone.now
    self.conferences.where("conferences.start_at <= ? AND conferences.end_at >= ? AND conferences.archived = ?", now, now, false)
  end

  def process_timezone
    self.start_at = Time.use_zone(self.timezone) { Time.zone.local_to_utc(self.start_at) } if (self.timezone.present? && self.start_at.present?)
    self.end_at = Time.use_zone(self.timezone) { Time.zone.local_to_utc(self.end_at) } if (self.timezone.present? && self.end_at.present?)
    return self
  end
end
