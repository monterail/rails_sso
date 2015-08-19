require "test_helper"

class RailsSso::SsoStrategyTest < ActiveSupport::TestCase
  test "does not store" do
    strategy = RailsSso::SsoStrategy.new(nil)

    refute strategy.store?
  end

  test "is valid when access token is present" do
    session = { access_token: "169783" }
    env = { "rack.session" => session }
    strategy = RailsSso::SsoStrategy.new(env)

    assert strategy.valid?
  end

  test "is valid when in test mode with access token mock" do
    env = { "rack.session" => {} }
    strategy = RailsSso::SsoStrategy.new(env)
    RailsSso.stubs(:test_mode).returns(true)
    RailsSso.stubs(:access_token_mock).returns("169783")

    assert strategy.valid?
  end

  test "is invalid when in test mode without access token mock" do
    env = { "rack.session" => {} }
    strategy = RailsSso::SsoStrategy.new(env)
    RailsSso.stubs(:test_mode).returns(true)
    RailsSso.stubs(:access_token_mock).returns(nil)

    refute strategy.valid?
  end

  test "is invalid when access token not present" do
    env = { "rack.session" => {} }
    strategy = RailsSso::SsoStrategy.new(env)

    refute strategy.valid?
  end

  test "authenticate! returns :success when sso can fetch user" do
    sso_app = mock()
    sso_app.stubs(:fetch_user_data).returns({ "uid" => "169783" })
    env = { "sso" => sso_app }
    strategy = RailsSso::SsoStrategy.new(env)

    assert_equal :success, strategy.authenticate!
  end

  test "authenticate! returns :failure when sso cannot fetch user" do
    sso_app = mock()
    sso_app.stubs(:fetch_user_data).returns(nil)
    env = { "sso" => sso_app }
    strategy = RailsSso::SsoStrategy.new(env)

    assert_equal :failure, strategy.authenticate!
  end
end
