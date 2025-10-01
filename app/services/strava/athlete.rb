module Strava
  class Athlete < Base
    def authorize_athlete()
      params = {
        client_id: Rails.application.credentials.strava[:client_id],
        client_secret: Rails.application.credentials.strava[:client_secret],
        redirect_uri: 'localhost:3000/exchange_token', # todo, update this
        response_type: 'code',
        scope: 'profile:read_all,activity:read_all'
      }
      result = request(:get, 'https://www.strava.com/oauth/authorize', {
        params: params,
      })
    end

  end
end