RailsSso.configure do |config|
  # name of oauth2 provider
  config.provider_name = 'example'
  # oauth keys for omniauth-example
  config.provider_key = ENV['PROVIDER_KEY']
  config.provider_secret = ENV['PROVIDER_SECRET']
  # path for fetching user data
  config.provider_profile_path = '/api/v1/profile'
  # set if you support single sign out
  config.provider_sign_out_path = '/api/v1/session'
  # enable cache (will use Rails.cache store)
  config.use_cache = Rails.application.config.action_controller.perform_caching
end
