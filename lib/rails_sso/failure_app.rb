module RailsSso
  class FailureApp < ::ActionController::Metal
    include ActionController::Redirecting
    include RailsSso::Engine.routes.url_helpers

    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    def respond
      redirect_to sign_in_path
    end
  end
end
