module RailsSso
  module Helpers
    def self.included(base)
      base.class_eval do
        helper_method :current_user_data, :user_signed_in?
      end
    end

    def current_user_data
      warden.user
    end

    def authenticate_user!
      warden.authenticate!
    end

    def user_signed_in?
      warden.authenticated?
    end

    def invalidate_access_token!
      if RailsSso.provider_sign_out_path
        access_token.delete(RailsSso.provider_sign_out_path)
      end

      warden.logout
    end

    def warden
      env['warden']
    end
  end
end
