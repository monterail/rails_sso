require 'faraday-http-cache'

module RailsSso
  class AccessToken
    attr_reader :token, :refresh_token

    delegate :get, :patch, :post, :put, :delete, to: :access_token

    def self.from_access_token(access_token)
      new(access_token.token, access_token.refresh_token)
    end

    def initialize(token, refresh_token)
      @token, @refresh_token = token, refresh_token
    end

    def refresh!
      self.class.from_access_token(access_token.refresh!)
    end

    def access_token
      @access_token ||= OAuth2::AccessToken.new(client, token, {
        refresh_token: refresh_token
      })
    end

    private

    def client
      strategy.client.tap do |c|
        if RailsSso.use_cache
          c.options[:connection_build] = Proc.new do |conn|
            conn.use :http_cache,
              store: Rails.cache,
              logger: Rails.logger,
              shared_cache: false

            conn.adapter Faraday.default_adapter
          end
        end
      end
    end

    def strategy
      @strategy ||= strategy_class.new(nil, RailsSso.provider_key, RailsSso.provider_secret)
    end

    def strategy_class
      "OmniAuth::Strategies::#{RailsSso.provider_name.classify}".constantize
    end
  end
end
