Rails.application.config.middleware.use OmniAuth::Builder do
  provider RailsSso.provider_name,
    RailsSso.provider_key,
    RailsSso.provider_secret,
    callback_path: RailsSso.provider_callback_path
end
