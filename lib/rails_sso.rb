module RailsSso
  mattr_accessor :application_controller
  @@application_controller = 'ApplicationController'

  mattr_accessor :provider_name
  mattr_accessor :provider_key
  mattr_accessor :provider_secret

  mattr_accessor :provider_profile_path
  mattr_accessor :provider_sign_out_path

  mattr_accessor :use_cache
  @@use_cache = false

  def self.configure
    yield self
  end

  def self.user_repository
    @@user_repository.constantize
  end

  def self.provider_callback_path
    "/sso/#{self.provider_name}/callback"
  end
end

require 'omniauth-oauth2'
require 'rails_sso/version'
require 'rails_sso/engine'
require 'rails_sso/helpers'
require 'rails_sso/access_token'
