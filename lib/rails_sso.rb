module RailsSso
  class Error < RuntimeError; end

  mattr_accessor :config

  def self.configure
    self.config = Configuration.new

    yield config
  end
end

require "warden"
require "omniauth-oauth2"
require "rails_sso/version"
require "rails_sso/app"
require "rails_sso/configuration"
require "rails_sso/engine"
require "rails_sso/helpers"
require "rails_sso/client"
require "rails_sso/response_error"
require "rails_sso/sso_strategy"
require "rails_sso/failure_app"
require "rails_sso/token_mock"
