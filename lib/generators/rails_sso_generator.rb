class RailsSsoGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  desc "Creates RailsSso initializer and mount sso routes."

  def copy_initializer
    template "sso.rb", "config/initializers/sso.rb"
  end

  def add_sso_routes
    route "mount RailsSso::Engine => '/sso', as: 'sso'"
  end
end
