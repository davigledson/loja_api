# app/controllers/api/v1/usuarios_controller.rb
module Api
  module V1
    class UsuariosController < ApplicationController
      before_action :authenticate_usuario! # Garante que o usuário esteja logado
      before_action :set_usuario, only: [:show, :update] # set_usuario para show, update, destroy
      def index
        render json: Usuario.all
      end
      # GET /api/v1/usuarios/:id
      def show
        # Garante que o usuário só pode ver seu próprio perfil
        if @usuario.id != current_usuario.id
          render json: { error: "Não autorizado a ver este perfil." }, status: :unauthorized
          return
        end
        render json: @usuario
      end

      # PATCH/PUT /api/v1/usuarios/:id
      def update
        # Garante que o usuário só pode atualizar seu próprio perfil
        if @usuario.id != current_usuario.id
          render json: { error: "Não autorizado a atualizar este perfil." }, status: :unauthorized
          return
        end

        # Permite atualizar apenas os campos que você quer expor
        if @usuario.update(usuario_params)
          render json: @usuario # Retorna o usuário atualizado
        else
          render json: { errors: @usuario.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # ... (index, create, destroy - se existirem e forem necessários)

      private

      def set_usuario
        @usuario = Usuario.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Usuário não encontrado." }, status: :not_found
      end

      def usuario_params
        # Permita apenas os campos que o usuário pode editar
        params.require(:usuario).permit(:nome, :email)
       
      end
    end
  end
end
