class PagesController < ApplicationController
  def home
    user = current_user
    access_token = user.strava_access_token

    # Initial attempt
    @activities = fetch_strava_data(access_token)

    # If first attempt failed due to expired token, refresh
    if @activities.nil? && access_token.present?
      begin
        # 1. refresh the token
        new_access_token = StravaService.new(nil).refresh_token_and_update_user(user)

        # 2. retry the original action with the new token
        @activities = fetch_strava_data(new_access_token)

        flash.now[:notice] = "Strava connection automatically renewed"

      rescue StandardError => e
        flash.now[:alert] = "Strava connection failed. Please re-authorize Strava."
        @activities = []
      end
    end
    # Renders app/views/pages/home.html.erb
  end

  private
  def fetch_strava_data(access_token)
    # reurn data on success, or raise error on failure
    return nil if access_token.blank?

    strava_service = StravaService.new(access_token)

    begin
      return strava_service.fetch_athlete
    rescue => e
      Rails.logger.warn("Strava fetch failed: #{e.message}")

      if e.message.include?('Status 401') || e.message.include?('Authorization Error')
        return nil # Signal a potential expired token
      end

      flash.now[:alert] = "Strava API error: #{e.message}"
      return []
    end
  end
end