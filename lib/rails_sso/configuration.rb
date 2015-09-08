module RailsSso
  class Configuration
    attr_accessor :application_controller
    attr_accessor :magic_enabled

    attr_writer :provider_url
    attr_accessor :provider_name
    attr_accessor :provider_key
    attr_accessor :provider_secret

    attr_accessor :provider_profile_path
    attr_accessor :provider_sign_out_path

    attr_accessor :use_cache

    attr_reader :test_mode
    attr_accessor :profile_mocks
    attr_accessor :access_token_mock

    attr_accessor :failure_app

    def initialize
      self.application_controller = "ApplicationController"
      self.magic_enabled = true
      self.use_cache = false
      self.test_mode = false
      self.profile_mocks = {}
      self.access_token_mock = nil
      self.failure_app = RailsSso::FailureApp
    end

    def provider_callback_path
      "/sso/#{provider_name}/callback"
    end

    def oauth2_strategy_class
      OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(provider_name.to_s)}")
    end

    def test_mode=(value)
      @test_mode = value
      OmniAuth.config.test_mode = value
    end

    def profile_mock
      profile_mocks.fetch(access_token_mock) do
        fail %Q{Mock "#{access_token_mock}" has not been setup!}
      end
    end

    def test_mode?
      @test_mode
    end

    def provider_url
      fail RailsSso::Error, "Provider url not set!" if @provider_url.nil?

      @provider_url
    end
  end
end
