module RailsSso
  class SsoStrategy < ::Warden::Strategies::Base
    include Utils

    def store?
      false
    end

    def valid?
      session[:access_token].present?
    end

    def authenticate!
      fetch_user_data.tap do |user|
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
