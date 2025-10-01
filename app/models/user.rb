# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:strava]

  validates :email, presence: true, unless: :uid_present?
  validates :password, presence: true, confirmation: true, unless: :uid_present?

  # Make sure you have migration columns for:
  # strava_uid:string, strava_access_token:string, strava_refresh_token:string, strava_token_expires_at:datetime

  # Check if the user was authenticated via OmniAuth
  def uid_present?
    provider.present? && uid.present?
  end

  def self.from_omniauth(auth)
    # The strava athelete ID is the unique identifier for a user
    strava_uid = auth.uid.to_s

    # extract credentials
    credentials = auth.credentials

    # Find an existing user by their Strava UID
    user = find_or_initialize_by(strava_uid: strava_uid)


    # ----------------------------------------------------
    # UPDATE or CREATE USER ATTRIBUTES
    # ----------------------------------------------------
    # 1. Update Profile Info (optional)
    Rails.logger.info("user in user model: #{user.inspect} \n\n")
    user.email      = auth.info.email if auth.info.email.present?
    user.first_name = auth.info.first_name
    user.last_name  = auth.info.last_name

    # 2. Update Credentials
    user.strava_access_token  = credentials.token
    user.strava_refresh_token = credentials.refresh_token
    # Convert epoch timestamp to Ruby DateTime
    user.strava_token_expires_at = Time.at(credentials.expires_at).to_datetime

    # 3. Save the user
    user.save
    return user
  end

  # Helper method to check if the Strava token is still valid
  def strava_token_expired?
    strava_token_expires_at.nil? || strava_token_expires_at < Time.zone.now
  end
end
