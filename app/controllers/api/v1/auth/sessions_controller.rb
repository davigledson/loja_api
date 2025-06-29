# app/controllers/api/v1/auth/sessions_controller.rb
module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        # Evita erro de CSRF (em API-only)
        skip_before_action :verify_authenticity_token, raise: false

        # Override do método sign_in para evitar usar sessão
        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource, store: false)
          token = request.env['warden-jwt_auth.token']
          render json: { message: 'Login efetuado com sucesso', usuario: resource, token: token }, status: :ok
        end

        def destroy
          # opcional: sign_out(resource_name)
          head :no_content
        end
      end
    end
  end
end
