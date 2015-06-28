module RailsSso
  class FailureApp < ::ActionController::Metal
    include ActionController::Redirecting
    include RailsSso::Engine.routes.url_helpers

    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    def respond
      if request.content_type == 'application/json'
        self.status = :unauthorized
        self.content_type = request.content_type
        self.response_body = ''
      else
        redirect_to sign_in_path
      end
    end
  end
end
