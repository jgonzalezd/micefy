class Conference < ActiveRecord::Base

  include ConferenceConcern

  belongs_to :event
  belongs_to :location
  has_many :slides, inverse_of: :conference, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :lecturers
  accepts_nested_attributes_for :lecturers, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :slides, allow_destroy: true
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: {scope: :event_id}
  validates_length_of :description, maximum: 500, too_long: 500

  #validates_format_of :embedded_url, :with => URI.regexp

  #before_save :process_lecturers
  before_create :set_security_hash
  validate :conference_dates_are_within_date_range

  acts_as_tagger
  # rescue nil is due to a bug with the gem
  acts_as_taggable rescue nil

  def dates_already_set?
    start_at.present? && end_at.present?
  end

  def dates_not_set?
    start_at.blank? || end_at.blank?
  end

  def start_date
    start_at.to_date.in_time_zone(event.timezone)
  end

  def in_time?(time = Time.zone.now)
      (start_at.blank? || end_at.blank?) ? false : (time >= start_at && time <= end_at)
  end

  private
    # Commented out because we want to let the Organizer adapt the lecturer's description for each conference.
    # def process_lecturers
    #   _new_lecturers = lecturers.select {|lecturer| lecturer.new_record? }
    #   _old_lecturers = lecturers.select {|lecturer| lecturer.persisted? }
    #   _old_lecturers.each do |lecturer|
    #     lecturer.save
    #   end
    #   _new_lecturers.each do |lecturer|
    #     _lecturer = Lecturer.find_by name: lecturer.name
    #     if _lecturer.present?
    #       _attr = lecturer.attributes
    #       _attr.delete("id")
    #       _lecturer.assign_attributes(_attr)
    #       _lecturer.country_code = lecturer.country_code
    #     else
    #       _lecturer = lecturer
    #     end
    #     lecturers.delete(lecturer)
    #     lecturers << _lecturer
    #     _lecturer.save
    #   end
    # end

    # set a security hash to confirm notifications through ajax
    def set_security_hash
      self.security_hash = Digest::MD5.hexdigest("#{SecureRandom.hex(10)}-#{DateTime.now.to_s}")
    end

    def conference_dates_are_within_date_range
      Time.use_zone(event.timezone) do
        errors.add(:start_at, :earlier_than_event, event_start_at: event.start_at.in_time_zone, conference_start_at: start_at.in_time_zone )  if start_at < event.start_at
        errors.add(:end_at, :later_than_event, event_end_at: event.end_at.in_time_zone, conference_end_at: end_at.in_time_zone ) if end_at > event.end_at
      end unless start_at.blank? || end_at.blank?
    end

    def notify_on_new_presentation(old_presentation)
      ConferencePresentationMailer.notification_on_new_presentation(self, old_presentation).deliver
    end
end

# == Schema Information
#
# Table name: conferences
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  start_at      :datetime
#  end_at        :datetime
#  event_id      :integer
#  location_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#  archived      :boolean
#  embedded_url  :string(255)
#  status        :string(255)
#  current_step  :integer          default(1)
#  steps         :integer
#  security_hash :string(255)
#
