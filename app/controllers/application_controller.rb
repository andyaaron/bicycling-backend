class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protect_from_forgery with: :exception

  # ------------------------------------------------------------------------
  # DEVISE REDIRECTION OVERRIDE
  # This method is called by Devise (e.g., after sign_in_and_redirect) to
  # determine the user's destination after successful authentication.
  # ------------------------------------------------------------------------
  def after_sign_in_path_for(resource)
    # 1. Check for a stored path (e.g., if the user tried to visit /dashboard)
    stored_location = stored_location_for(resource)

    # 2. If a stored location exists, use it. Otherwise, default to the
    # root path (which maps to home#index in our case)
    stored_location || root_path
  end
end
