module Api
  module V1
    class CarrinhosController < ApplicationController
      before_action :set_carrinho, only: [:show, :update, :destroy]

      def index
        render json: Carrinho.all
      end

      def show
        render json: @carrinho
      end

      def create
        carrinho = Carrinho.new(carrinho_params)
        if carrinho.save
          render json: carrinho, status: :created
        else
          render json: { errors: carrinho.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @carrinho.update(carrinho_params)
          render json: @carrinho
        else
          render json: { errors: @carrinho.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @carrinho.destroy
        head :no_content
      end

      private

      def set_carrinho
        @carrinho = Carrinho.find(params[:id])
      end

      def carrinho_params
        params.require(:carrinho).permit(:usuario_id)
      end
    end
  end
end