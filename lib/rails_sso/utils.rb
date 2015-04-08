module RailsSso
  module Utils
    def fetch_user_data
      FetchUser.new(provider_client.token!(session[:access_token])).call
    rescue ResponseError => e
      refresh_access_token! do
        FetchUser.new(provider_client.token!(session[:access_token])).call
      end if e.code == :unauthenticated
    end

    def refresh_access_token!
      save_access_token!(access_token.refresh!)

      yield if block_given?
    rescue ::OAuth2::Error
      nil
    rescue ResponseError => e
      nil if e.code == :unauthenticated
    end

    def save_access_token!(access_token)
      session[:access_token] = access_token.token
      session[:refresh_token] = access_token.refresh_token
    end

    def access_token
      OAuth2::AccessToken.new(oauth2_strategy.client, session[:access_token], {
        refresh_token: session[:refresh_token]
      })
    end

    def provider_client
      @provider_client ||= RailsSso::Client.new(RailsSso.provider_url) do |conn|
        if RailsSso.use_cache
          conn.use :http_cache,
            store: Rails.cache,
            logger: Rails.logger,
            serializer: Marshal,
            shared_cache: false
        end

        conn.adapter Faraday.default_adapter
      end
    end

    def oauth2_strategy
      oauth2_strategy_class.new(request, RailsSso.provider_key, RailsSso.provider_secret)
    end

    def oauth2_strategy_class
      OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(RailsSso.provider_name.to_s)}")
    end
  end
end
