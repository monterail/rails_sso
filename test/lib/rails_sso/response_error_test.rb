require 'test_helper'

class RailsSso::ResponseErrorTest < ActiveSupport::TestCase
  test "assigns error code" do
    err = RailsSso::ResponseError.new(:err_code)

    assert_equal err.code, :err_code
  end

  test "assigns unauthenticated error message from locales" do
    err = RailsSso::ResponseError.new(:unauthenticated)

    assert_equal err.message, "You're not authenticated"
  end

  test "assigns unknown error message from locales" do
    err = RailsSso::ResponseError.new(:unknown)

    assert_equal err.message, "Something wrong happened"
  end
end
