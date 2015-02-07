#config/initalizers/omniauth.rb
OmniAuth.config.logger = Rails.logger
OmniAuth.logger.progname = "omniauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'],
      {
        scope: ['email', 'profile'],
        access_type: 'offline',
        prompt: 'consent'
      }
  else
    provider :developer,
      :fields => [:email],
      :uid_field => :email
  end
end