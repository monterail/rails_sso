require "test_helper"

class RailsSso::AppTest < ActiveSupport::TestCase
  test "#fetch_user_data returns data based on access token" do
    strategy = mock()
    session = { access_token: "169783" }
    client = RailsSso::Client.new(build_adapter)

    app = RailsSso::App.new(strategy, session, client)

    assert_equal user_data, app.fetch_user_data
  end

  test "#fetch_user_data when stale token refreshes token and returns data" do
    new_token = mock()
    new_token.stubs(:token).returns("169783")
    new_token.stubs(:refresh_token).returns("new_refresh_token")
    new_token.stubs(:options=)
    adapter = build_adapter
    adapter.stubs(:id).returns("123")
    adapter.stubs(:secret).returns("456")
    adapter.stubs(:get_token).returns(new_token)
    strategy = mock()
    strategy.stubs(:client).returns(adapter)
    session = { access_token: "stale", refresh_token: "refresh_token" }
    client = RailsSso::Client.new(adapter)

    app = RailsSso::App.new(strategy, session, client)

    assert_equal user_data, app.fetch_user_data
    assert_equal "169783", session[:access_token]
    assert_equal "new_refresh_token", session[:refresh_token]
  end

  test "#fetch_user_data when invalid token returns nil and reset access token" do
    error_response = mock()
    error_response.stubs(:error=)
    error_response.stubs(:parsed).returns({
      "error" => "401",
      "error_description" => "error description"
    })
    error_response.stubs(:body).returns("")
    adapter = build_adapter
    adapter.stubs(:id).returns("123")
    adapter.stubs(:secret).returns("456")
    adapter.stubs(:get_token).raises(::OAuth2::Error.new(error_response))
    strategy = mock()
    strategy.stubs(:client).returns(adapter)
    session = { access_token: "invalid", refresh_token: "invalid" }
    client = RailsSso::Client.new(adapter)

    app = RailsSso::App.new(strategy, session, client)

    assert_equal nil, app.fetch_user_data
  end

  def user_data
    { "uid" => "1234" }
  end

  def valid_headers
    build_request_headers("169783")
  end

  def stale_headers
    build_request_headers("stale")
  end

  def invalid_headers
    build_request_headers("invalid")
  end

  def build_adapter
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/v1/me", invalid_headers) do |env|
          [401, { "Content-Type" => "application/json" }, ""]
        end
        stub.get("/api/v1/me", stale_headers) do |env|
          [401, { "Content-Type" => "application/json" }, ""]
        end
        stub.get("/api/v1/me", valid_headers) do |env|
          [200, { "Content-Type" => "application/json" }, user_data]
        end
      end
    end
  end

  def build_request_headers(token)
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type"  => "application/json"
    }
  end
end
