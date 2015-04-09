require 'test_helper'

class RailsSso::FailureAppTest < ActiveSupport::TestCase
  test ".call runs respond action and redirects to sso" do
    env = {
      'REQUEST_URI' => 'http://test.host',
      'HTTP_HOST' => 'test.host'
    }
    response = RailsSso::FailureApp.call(env).to_a

    assert_equal 302, response.first
    assert_equal 'http://test.host/sso/', response.second['Location']
  end
end
