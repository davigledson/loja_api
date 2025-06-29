module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        before_action :configure_permitted_parameters

        private

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :email, :password, :password_confirmation, :papel])
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              message: 'Usuário criado com sucesso',
              usuario: resource
            }, status: :created
          else
            render json: {
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
