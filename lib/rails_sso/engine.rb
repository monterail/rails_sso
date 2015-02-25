module RailsSso
  class Engine < Rails::Engine
    initializer 'sso.helpers' do
      ActiveSupport.on_load(:action_controller) do
        include RailsSso::Helpers
      end
    end

    initializer 'sso.omniauth', after: :load_config_initializers, before: :build_middleware_stack do |app|
      if RailsSso.provider_name
        app.config.middleware.use OmniAuth::Builder do
          provider RailsSso.provider_name,
            RailsSso.provider_key,
            RailsSso.provider_secret,
            callback_path: RailsSso.provider_callback_path
        end
      end
    end
  end
end
