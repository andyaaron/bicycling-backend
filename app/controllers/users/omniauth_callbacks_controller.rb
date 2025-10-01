class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :exception, except: [:strava]
  def strava
    # 1. access the authorization hash provided by OmniAuth
    auth = request.env["omniauth.auth"]

    # 2. Process the Data in the User model
    # We delegate the core logic (finding/creating the user, updating tokens)
    # to the `User.from_omniauth` method to keep the controller clean.
    @user = User.from_omniauth(auth)

    Rails.logger.debug("user in strava: #{@user.inspect} \n\n")

    # 3. Handle Success (User found/created)
    if @user.persisted?
      # `persisted?` checks if the record was successfully saved to the db
      # Devise method to sign in the user and redirect.
      # `event: :authentication` tells Devise this is a sign-in event
      sign_in_and_redirect @user, event: :authentication

      # set a friendly success message that will appear on the next page
      set_flash_message(:notice, :success, kind: "Strava") if is_navigational_format?

    # 4. Handle failure (Model validation failed)
    else
      # If the model validation failed (e.g., missing mandatory fields)
      # we display the errors
      flash[:alert] = @user.errors.full_messages.join("\n")

      # We store the Strava data in the session (minus the 'extra' raw data,
      # which can be large) so it can be used to pre-fill the registration form
      # if the user needs to manually finish sign-up
      session["devise.strava_data"] = auth.except("extra")

      # Redirect to the sign-up page
      redirect_to root_path
    end

  rescue => e
    # 5. Handle exceptions
    Rails.logger.error "Strava Omniauth Error: #{e.message}"
    set_flash_message(:alert, :failure, kind: "Strava", reason: "an internal error occurred")
    redirect_to root_path
  end

  # Override Devise's failure action to redirect correctly
  def failure
    redirect_to root_path, alert: "Strava authorization failed. Please try again."
  end

  def auth
    request.env[omniauth.auth]
  end
end
