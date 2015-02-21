require 'test_helper'

class RailsSso::FetchUserTest < ActiveSupport::TestCase
  test "success call should fetch user with access token and return parsed data" do
    data = RailsSso::FetchUser.new(success_client).call

    assert_equal data['name'], user_data['name']
    assert_equal data['email'], user_data['email']
  end

  test "unauthenticated call should raise error" do
    err = assert_raises(RailsSso::ResponseError) { RailsSso::FetchUser.new(unauthenticated_client).call }
    assert_equal :unauthenticated, err.code
  end

  test "unknown call should raise error" do
    err = assert_raises(RailsSso::ResponseError) { RailsSso::FetchUser.new(unknown_client).call }
    assert_equal :unknown, err.code
  end

  def user_data
    {
      'name' => 'Kowalski',
      'email' => 'jan@kowalski.pl'
    }
  end

  def response_headers
    { 'Content-Type' => 'application/json' }
  end

  def success_client
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/api/v1/me') { |env| [200, response_headers, user_data] }
      end
    end
  end

  def unauthenticated_client
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/api/v1/me') { |env| [401, response_headers, {}] }
      end
    end
  end

  def unknown_client
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/api/v1/me') { |env| [500, response_headers, {}] }
      end
    end
  end
end
