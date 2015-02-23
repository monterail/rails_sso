require 'test_helper'

class RailsSso::HelpersTest < ActiveSupport::TestCase
  class DummyController
    def self.helper_method(*list)
    end

    include RailsSso::Helpers

    attr_reader :session

    def initialize(session)
      @session = session
    end
  end

  AccessToken = Struct.new(:token, :refresh_token)

  def setup
    RailsSso.provider_name = 'OAuth2'
    RailsSso.provider_key = 'provider_key'
    RailsSso.provider_secret = 'provider_secret'

    @controller = DummyController.new(session)
  end

  def session
    @session ||= {}
  end

  test "#current_user_data will return nil if not authenticated" do
    assert_nil @controller.current_user_data
  end

  test "#current_user_data will return user data if authenticated" do
    # TODO: pending
  end

  test "#user_signed_in? returns false if not authenticated" do
    refute @controller.user_signed_in?
  end

  test "#user_signed_in? returns true if authenticated" do
    # TODO: pending
  end

  test "#access_token returns a new OAuth2::AccessToken object" do
    session[:access_token] = 'abc'
    session[:refresh_token] = 'def'

    access_token = @controller.access_token

    assert_instance_of OAuth2::AccessToken, access_token
    assert_equal 'abc', access_token.token
    assert_equal 'def', access_token.refresh_token
  end

  test "#invalidate_access_token! will call Single Sign-Out with access token" do
    # @TODO: pending
  end

  test "save_access_token! will copy access and refresh token to session" do
    access_token = AccessToken.new('abc', '1337')

    @controller.save_access_token!(access_token)

    assert_equal 'abc', session[:access_token]
    assert_equal '1337', session[:refresh_token]
  end

  test "#refresh_access_token! will refresh token and copy new values" do
    # @TODO: pending
  end
end
