class StravaApiService
  include httparty

  def base_url
    'https://www.strava.com/api/v3'
  end

  def initialize(params = {})
    @access_token = params[:access_token]
    @headers = { "Authorization" => "Bearer #{@access_token}"}
  end

  def request(method, path, options = {})
    HTTP.auth("Bearer #{@access_token}")
        .use(logging: { logger: Logger.new(STDOUT) })
        .headers({
          "User-Agent" => "Clipflow",
        })
        .send(method, request_url(path), params: options[:params])
  end

  def request_url(path)
    "#{base_url}#{path}"
  end

  def authorize_athlete()
    self.class.get('https://www.strava.com/oauth/authorize')
  end

  def fetch_athlete_data()
    self.class.get('/athlete', headers: @headers)
  end

  # fetch activities filtered by type
  def fetch_bicycling_activities()
    options = { query: { type: 'Ride' }, headers: @headers }
    self.class.get('/activities', options)
  end
end