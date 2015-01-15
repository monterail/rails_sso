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

    private

    def fetch_user
      return unless session[:access_token]

      RailsSso::FetchUser.new(access_token).get_and_cache
    rescue ::OAuth2::Error
      save_access_token!(access_token.refresh!)

      RailsSso::FetchUser.new(access_token).get_and_cache
    end

    def access_token
      RailsSso::AccessToken.new(session[:access_token], session[:refresh_token])
    end
  end
end
