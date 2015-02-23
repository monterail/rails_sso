module RailsSso
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_user_data, :user_signed_in?
      end
    end

    def current_user_data
      @current_user_data ||= fetch_user_data
    end

    def user_signed_in?
      !!current_user_data
    end

    def authenticate_user!
      redirect_to sso.sign_in_path unless user_signed_in?
    end

    def access_token
      OAuth2::AccessToken.new(oauth2_strategy.client, session[:access_token], {
        refresh_token: session[:refresh_token]
      })
    end

    def invalidate_access_token!
      if RailsSso.provider_sign_out_path
        access_token.delete(RailsSso.provider_sign_out_path)
      end

      reset_session
    end

    def save_access_token!(access_token)
      session[:access_token] = access_token.token
      session[:refresh_token] = access_token.refresh_token
    end

    def refresh_access_token!
      save_access_token!(access_token.refresh!)

      yield if block_given?
    rescue ::OAuth2::Error
      nil
    end

    private

    def oauth2_strategy
       oauth2_strategy_class.new(nil, RailsSso.provider_key, RailsSso.provider_secret)
    end

    def oauth2_strategy_class
      "OmniAuth::Strategies::#{RailsSso.provider_name.camelize}".constantize
    end

    def provider_client
      @provider_client ||= RailsSso::Client.new(RailsSso.provider_url) do |conn|
        if RailsSso.use_cache
          conn.use :http_cache,
            store: Rails.cache,
            logger: Rails.logger,
            shared_cache: false
        end

        conn.adapter Faraday.default_adapter
      end
    end

    def fetch_user_data
      return unless session[:access_token]

      RailsSso::FetchUser.new(provider_client.token!(session[:access_token])).call
    rescue ResponseError => e
      refresh_access_token! do
        RailsSso::FetchUser.new(provider_client.token!(session[:access_token])).call
      end if e.code == :unauthenticated
    end
  end
end
