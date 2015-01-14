module RailsSso
  class SessionsController < RailsSso.application_controller.constantize
    skip_before_action :authenticate_user!, only: [:create]

    def create
      session[:access_token] = auth_hash.credentials.token
      session[:refresh_token] = auth_hash.credentials.refresh_token

      redirect_to root_path
    end

    def destroy
      invalidate_user!

      redirect_to root_path
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
