RailsSso.configure do |config|
  config.provider_name = 'developer'
  config.provider_key = 'key'
  config.provider_secret = 'secret'
  config.provider_profile_path = '/api/v1/me'
  config.provider_sign_out_path = '/api/v1/me'
  config.use_cache = false
  config.user_fields = [
    :email,
    :name
  ]
  config.user_repository = 'UserRepository'
end
