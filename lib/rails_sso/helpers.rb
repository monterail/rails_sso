module RailsSso
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_user_data, :user_signed_in?
      end
    end

    def current_user_data
      @current_user_data ||= warden.authenticate
    end

    def authenticate_user!
      unless user_signed_in?
        session[:rails_sso_return_path] = request.path
      end

      warden.authenticate!
    end

    def user_signed_in?
      warden.authenticate?
    end

    def sign_in_with_access_token!(access_token)
      sso_app.save_access_token!(access_token)
    end

    def sign_out!
      sso_app.invalidate_access_token!

      warden.logout
    end

    def warden
      request.env['warden']
    end

    def sso_app
      request.env['sso']
    end
  end
end
