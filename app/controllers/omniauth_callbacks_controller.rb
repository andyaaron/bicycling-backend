class OmniauthCallbacksController
  def strava
    # 1. access the authorization hash provided by OmniAuth
    auth = request.env["omniauth.auth"]


    user = User.find_or_create_by(uid: auth['uid'], provider: auth[:provider])
    if user
      user.password = "strava_auth"
      session[:user_id] = user.id
      user.save
    end
  end

  def auth
    request.env[omniauth.auth]
  end
end
