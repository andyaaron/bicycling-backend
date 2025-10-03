require_relative 'strava_api_errors'
class StravaService
  BASE_URL = "https://www.strava.com/api/v3"

  def initialize(access_token)
    # store the token for authorization
    @access_token = access_token
  end

  def refresh_token_and_update_user(user)
    Rails.logger.info("Attempting to refresh Strava token for user #{user.id}")

    # 1. prepare the refresh request payload
    payload = {
      client_id: Rails.application.credentials.strava[:client_id],
      client_secret: Rails.application.credentials.strava[:client_secret],
      refresh_token: user.strava_refresh_token,
      grant_type: "refresh_token"
    }

    # 2. make api call
    response = HTTP.post(BASE_URL + "/oauth/token", form: payload)

    unless response.code.to_i.between?(200, 299)
      raise "Strava Refresh Error: Status #{response.code}"
    end

    # 3. parse the successful response
    data = JSON.parse(response.body)

    # 4. update the user record
    user.update!(
      strava_access_token: data["access_token"],
      strava_refresh_token: data["refresh_token"],
      strava_token_expires_at: Time.at(data["expires_at"])
    )

    Rails.logger.info("Strava token refreshed for user #{user.id}")
    data['access_token']
  end

  def fetch_athlete
    headers = { "Authorization" => "Bearer #{@access_token}"}
    response = HTTP.headers(headers).get(BASE_URL + "/athlete")
    Rails.logger.info("StravaService#fetch_athlete: #{response}")
    if response.code.to_i.between?(200, 299)
      JSON.parse(response.body)
    else
      error_message = JSON.parse(response.body)["message"] rescue "Unknown error"

      raise "Strava API Error: Status #{response.code}, Message: #{error_message}"
    end
  end
end