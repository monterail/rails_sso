require 'test_helper'

class RailsSso::SessionsControllerTest < ActionController::TestCase
  def setup
    @routes = RailsSso::Engine.routes

    @auth_hash = OmniAuth::AuthHash.new({
      provider: 'developer',
      uid: '1',
      name: 'Kowalski',
      email: 'jan@kowalski.pl',
      key: 'value'
    })

    OmniAuth.config.mock_auth[:developer] = @auth_hash

    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:developer]
  end

  def teardown
    OmniAuth.config.mock_auth[:developer] = nil
  end

  test 'create should save access token and  redirect to root path' do
    @controller.expects(:sign_in_with_access_token!).with(@auth_hash.credentials).once

    get :create, { provider: 'developer' }

    assert_redirected_to main_app.root_path
  end

  test 'destroy should invalidate access token and redirect to root path' do
    @controller.expects(:sign_out!).once

    delete :destroy, {}, { access_token: 'abc', refresh_token: 'def' }

    assert_redirected_to main_app.root_path
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end
end
