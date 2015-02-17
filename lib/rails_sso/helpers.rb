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
      RailsSso::AccessToken.new(session[:access_token], session[:refresh_token])
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

    def fetch_user_data
      return unless session[:access_token]

      RailsSso::FetchUser.new(access_token).call
    rescue ::OAuth2::Error
      refresh_access_token! do
        RailsSso::FetchUser.new(access_token).call
      end
    end
  end
end
