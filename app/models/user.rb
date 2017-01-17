# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  name                   :string(255)
#  position               :string(255)
#  company                :string(255)
#  contact_email          :string(255)
#

#  username               :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  name                   :string(255)
#  position               :string(255)
#  company                :string(255)
#

class User < ActiveRecord::Base
  # TODO: remove username field.
  # Include default devise modules. Others available are:
  # :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :token_authenticatable, #:confirmable,
         :rememberable, :trackable, :validatable,  :omniauthable, :omniauth_providers => [:twitter]

  has_many :event_users, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :events, through: :event_users
  has_many :announces, dependent: :destroy
  has_many :identities, dependent: :destroy

  accepts_nested_attributes_for :identities

  validates :contact_email, :allow_blank => true, format: Devise.email_regexp
  validates :name, presence: true

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  acts_as_voter

  def subscribed_events
    Event.joins(:event_users).where({event_users: {user_id: self.id, rsvp: "yes"}})
  end

  def attending_event
    now = Time.zone.now
    event_users.joins(:event).where(:'event_users.checkin' => true).where("events.start_at < ? AND events.end_at > ?", now, now).first
  end

  def checkout(event)
    event.update_attribute(checkin: false)
  end

  def suggested_events
    scope = Event.where.not(status: :draft).where.not(id: subscribed_events.map(&:id))
    if scope.any?
      scope
    else
      Event.none
    end
  end

  ## Chatroom methods.
  def in_this(room_id)
    $redis.sismember("user:#{self.id}:rooms:active", "room:#{room_id}")
  end

  def add_to_cache(user_id)
    user = User.find_by_id(user_id)
    $redis.hmset("user:#{user_id}", "name",user.name,"email",user.email)
  end

  def update_cache (user_id) #after_update

  end
  #======= End chatroom methods =============

  class << self

    def find_for_oauth_authentication(options)
      User.joins(:identities).find_by(:"identities.uid" => options[:uid], :"identities.provider" => options[:provider])
    end

    def find_for_twitter_oauth(auth, signed_in_resource = nil)
      User.find_by(:provider => auth.provider, :uid => auth.uid)
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.twitter_data"]
          user.provider = data["provider"] if user.provider.blank?
          user.uid      = data["uid"]      if user.uid.blank?
        end
      end
    end

  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  name                   :string(255)
#  position               :string(255)
#  company                :string(255)
