require 'test_helper'

class RailsSso::FetchUserTest < ActiveSupport::TestCase
  class AccessToken
    def initialize(client)
      @client = client
    end

    def get(path)
      OAuth2::Response.new(@client.get(path))
    end
  end

  def setup
    @access_token = AccessToken.new(setup_access_token_client)
  end

  test "call should fetch user with access token and yield parsed data" do
    called = false

    RailsSso::FetchUser.new(@access_token).call do |data|
      called = true

      assert_equal data['name'], user_data['name']
      assert_equal data['email'], user_data['email']
    end

    assert called, 'RailsSso::FetchUser#call should yield fetched data'
  end

  def setup_access_token_client
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/api/v1/me') { |env| [200, { 'Content-Type' => 'application/json' }, user_data] }
      end
    end
  end

  def user_data
    {
      'name' => 'Kowalski',
      'email' => 'jan@kowalski.pl',
      'key' => 'value'
    }
  end
end
