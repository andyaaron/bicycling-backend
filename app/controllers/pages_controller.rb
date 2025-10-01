class PagesController < ApplicationController
  def home
    # access_token = current_user.strava_access_token
    # strava_service = StravaApiService.new(access_token)
    # response = strava_service.fetch_bicycling_activities

    # if response?.success
    #   @activities = JSON.parse(response.body)
    # else
    #   flash.now[:alert] = "Could not fetch Strava data: #{response.code}"
    #   @activities = []
    # end

    # Renders app/views/pages/home.html.erb
  end
end