module Strava
  class Base
    def base_url
      'https://www.strava.com/api/v3'
    end

    def initialize(params = {})
      @access_token = params[:access_token]
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
  end
end