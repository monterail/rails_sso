module RailsSso
  class SsoStrategy < ::Warden::Strategies::Base
    def store?
      false
    end

    def valid?
      session[:access_token].present? || access_token_mock
    end

    def authenticate!
      user = env["sso"].fetch_user_data

      case
      when user.nil?
        fail! "strategies.sso.failed"
      else
        success! user
      end
    end

    private

    def access_token_mock
      RailsSso.access_token_mock if RailsSso.test_mode
    end
  end
end

Warden::Strategies.add(:sso, RailsSso::SsoStrategy)
