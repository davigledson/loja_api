module Api
  module V1
    class FavoritosController < ApplicationController
      before_action :set_favorito, only: [:show, :destroy]

      def index
        render json: Favorito.all
      end

      def show
        render json: @favorito
      end

      def create
        favorito = Favorito.new(favorito_params)
        if favorito.save
          render json: favorito, status: :created
        else
          render json: { errors: favorito.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @favorito.destroy
        head :no_content
      end

      private

      def set_favorito
        @favorito = Favorito.find(params[:id])
      end

      def favorito_params
        params.require(:favorito).permit(:usuario_id, :produto_id)
      end
    end
  end
end