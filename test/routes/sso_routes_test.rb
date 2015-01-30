require 'test_helper'

class SsoRoutesTest < ActionController::TestCase
  def setup
    @routes = RailsSso::Engine.routes
  end

  test 'should route /sign_out' do
    assert_routing({
      method: 'delete',
      path: '/sign_out'
    }, {
      controller: 'rails_sso/sessions',
      action: 'destroy'
    })
  end

  test 'should route /:provider/callback' do
    assert_routing('/example/callback', {
      controller: 'rails_sso/sessions',
      action: 'create',
      provider: 'example'
    })
  end
end
