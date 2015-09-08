module RailsSso
  class Engine < Rails::Engine
    initializer "sso.helpers" do
      if RailsSso.config.magic_enabled
        ActiveSupport.on_load(:action_controller) do
          include RailsSso::Helpers
        end
      end
    end

    initializer "sso.omniauth", after: :load_config_initializers, before: :build_middleware_stack do |app|
      if RailsSso.config.provider_name
        RailsSso.config.oauth2_strategy_class.class_eval do
          def setup_phase
            setup_sso!

            super
          end

          def other_phase
            setup_sso!

            call_app!
          end

          def mock_call!(*)
            setup_sso!

            super
          end

          def setup_sso!
            env["sso"] ||= RailsSso::App.new(self, session, sso_client)
          end

          def sso_client
            if RailsSso.config.test_mode
              RailsSso::Client.build_fake(RailsSso.config.provider_url)
            else
              RailsSso::Client.build_real(RailsSso.config.provider_url)
            end
          end
        end

        app.config.middleware.use OmniAuth::Builder do
          provider RailsSso.config.provider_name,
            RailsSso.config.provider_key,
            RailsSso.config.provider_secret,
            callback_path: RailsSso.config.provider_callback_path
        end

        app.config.middleware.insert_after OmniAuth::Builder, Warden::Manager do |manager|
          manager.default_strategies :sso
          manager.failure_app = RailsSso.config.failure_app
        end
      end
    end
  end
end
