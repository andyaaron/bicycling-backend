Rails.application.routes.draw do
  resources :stravas
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # route for omniauth
  get "/auth/strava/callback", to: "omniauth_callbacks#strava"

  # Defines the root path route ("/")
  root to: 'pages#home'
end
