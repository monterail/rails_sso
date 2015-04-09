module RailsSso
  class SsoStrategy < ::Warden::Strategies::Base
    def store?
      false
    end

    def valid?
      session[:access_token].present?
    end

    def authenticate!
      env['sso'].fetch_user_data.tap do |user|
        if user.nil?
          fail! 'strategies.sso.failed'
        else
          success! user
        end
      end
    end
  end
end

Warden::Strategies.add(:sso, RailsSso::SsoStrategy)
