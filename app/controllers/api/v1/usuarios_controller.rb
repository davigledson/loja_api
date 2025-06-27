module Api
  module V1
    class UsuariosController < ApplicationController
      before_action :set_usuario, only: [:show, :update, :destroy]

      def index
        usuarios = Usuario.all
        render json: usuarios
      end

      def show
        render json: @usuario
      end

      def create
        usuario = Usuario.new(usuario_params)
        if usuario.save
          render json: usuario, status: :created
        else
          render json: { errors: usuario.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @usuario.update(usuario_params)
          render json: @usuario
        else
          render json: { errors: @usuario.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @usuario.destroy
        head :no_content
      end

      private

      def set_usuario
        @usuario = Usuario.find(params[:id])
      end

      def usuario_params
        params.require(:usuario).permit(:nome, :email, :senha, :papel)
      end
    end
  end
end
