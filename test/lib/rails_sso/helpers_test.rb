require "test_helper"

class RailsSso::HelpersTest < ActionController::TestCase
  tests ApplicationController

  def setup
    @mock_warden = OpenStruct.new
    @controller.request.env["warden"] = @mock_warden
  end

  test "provide access to warden instance" do
    assert_equal @mock_warden, @controller.warden
  end

  test "proxy signed_in? to authenticate?" do
    @mock_warden.expects(:authenticate?).once
    @controller.user_signed_in?
  end

  test "proxy current_user_data to authenticate" do
    @mock_warden.expects(:authenticate).once
    @controller.current_user_data
  end

  test "proxy authenticate_user! to authenticate!" do
    @mock_warden.expects(:authenticate!).once
    @controller.authenticate_user!
  end

  test "keep current path in session during authentication" do
    @mock_warden.stubs(:authenticate!)
    @request.stubs(:path).returns("something")

    @controller.authenticate_user!

    assert_equal "something", @controller.session[:rails_sso_return_path]
  end
end
