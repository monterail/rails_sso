module RailsSso
  class SessionsController < RailsSso.application_controller.constantize
    include Utils

    skip_before_action :authenticate_user!, only: [:create]

    def create
      save_access_token!(auth_hash.credentials)

      redirect_to root_path
    end

    def destroy
      invalidate_access_token!

      redirect_to root_path
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
