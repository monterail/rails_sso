module RailsSso
  class App
    attr_reader :strategy, :session, :provider_client

    def initialize(strategy, session, provider_client)
      @strategy, @session, @provider_client = strategy, session, provider_client
    end

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
      return token_mock if RailsSso.config.test_mode

      OAuth2::AccessToken.new(strategy.client, session[:access_token], {
        refresh_token: session[:refresh_token]
      })
    end

    def invalidate_access_token!
      if RailsSso.config.provider_sign_out_path
        access_token.delete(RailsSso.config.provider_sign_out_path)
      end
    end

    private

    def token_mock
      RailsSso::TokenMock.new
    end
  end
end
