module RailsSso
  class App
    attr_reader :strategy, :session

    def initialize(strategy, session)
      @strategy, @session = strategy, session
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
      return token_mock if RailsSso.test_mode

      OAuth2::AccessToken.new(strategy.client, session[:access_token], {
        refresh_token: session[:refresh_token]
      })
    end

    def invalidate_access_token!
      if RailsSso.provider_sign_out_path
        access_token.delete(RailsSso.provider_sign_out_path)
      end
    end

    def provider_client
      @provider_client ||= RailsSso::Client.new(RailsSso.provider_url) do |conn|
        case
        when RailsSso.test_mode
          mock_connection(conn)
        else
          setup_connection(conn)
        end
      end
    end

    private

    def setup_connection(conn)
      if RailsSso.use_cache
        conn.use :http_cache,
          store: Rails.cache,
          logger: Rails.logger,
          serializer: Marshal,
          shared_cache: false
      end

      conn.adapter Faraday.default_adapter
    end

    def mock_connection(conn)
      conn.adapter :test do |stub|
        stub.get(RailsSso.provider_profile_path) { |env| [200, {}, profile_mock] }
      end
    end

    def profile_mock
      RailsSso.profile_mock.to_json
    end

    def token_mock
      RailsSso::TokenMock.new
    end
  end
end