Rails.application.config.middleware.use OmniAuth::Builder do
  # The provider name will be ':strava', leading to the path /auth/strava
  provider :strava, Rails.application.credentials.strava[:client_id], Rails.application.credentials.strava[:client_secret],
    # Define permissions requesting from user
    # https://developers.strava.com/docs/authentication/
    scope: 'activity:read_all'
end