require "test_helper"

class RailsSso::ConfigurationTest < ActiveSupport::TestCase
  test "#provider_url fails if not yet provided" do
    config = RailsSso::Configuration.new

    assert_raises RailsSso::Error, "Provider url not set!" do
      config.provider_url
    end
  end
end
