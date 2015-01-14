module RailsSso
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_user, :user_signed_in?
      end
    end

    def current_user
      @current_user ||= fetch_user
    end

    def user_signed_in?
      !!current_user
    end

    def authenticate_user!
      redirect_to sign_in_path unless user_signed_in?
    end

    def invalidate_user!
      if RailsSso.provider_sign_out_path
        access_token.delete(RailsSso.provider_sign_out_path)
      end

      reset_session
    end

    private

    def fetch_user
      return unless session[:access_token]

      RailsSso::FetchUser.new(access_token, session).get_and_cache
    rescue ::OAuth2::Error
      nil
    end

    def access_token
      OAuth2::AccessToken.new(oauth_client, session[:access_token], {
        refresh_token: session[:refresh_token]
      })
    end

    def oauth_client
      oauth_strategy.client
    end

    def oauth_strategy
      oauth_strategy_class.new(nil, RailsSso.provider_key, RailsSso.provider_secret)
    end

    def oauth_strategy_class
      "OmniAuth::Strategies::#{RailsSso.provider_name.classify}".constantize
    end
  end
end
