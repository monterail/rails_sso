module RailsSso
  class Engine < Rails::Engine
    initializer 'sso.helpers' do
      ActiveSupport.on_load(:action_controller) do
        include RailsSso::Helpers
      end
    end
  end
end
