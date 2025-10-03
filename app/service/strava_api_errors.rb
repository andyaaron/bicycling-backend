# frozen_string_literal: true

class StravaApiErrors
  # General API error for any non-2xx
  class StravaApiError < StandardError; end

  class InvalidTokenError < StravaApiError; end
end
