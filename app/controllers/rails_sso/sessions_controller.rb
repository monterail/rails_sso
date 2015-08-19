module RailsSso
  class SessionsController < RailsSso.application_controller.constantize
    skip_before_action :authenticate_user!, only: [:create]

    def create
      sign_in_with_access_token!(auth_hash.credentials)

      redirect_to session.delete(:rails_sso_return_path) || root_path
    end

    def destroy
      sign_out!

      redirect_to root_path
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
