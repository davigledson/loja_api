module Api
  module V1
    class ItensCarrinhoController < ApplicationController
      before_action :set_item, only: [:show, :update, :destroy]

      def index
        render json: ItemCarrinho.all
      end

      def show
        render json: @item
      end

      def create
        item = ItemCarrinho.new(item_params)
        if item.save
          render json: item, status: :created
        else
          render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @item.update(item_params)
          render json: @item
        else
          render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @item.destroy
        head :no_content
      end

      private

      def set_item
        @item = ItemCarrinho.find(params[:id])
      end

      def item_params
        params.require(:item_carrinho).permit(:carrinho_id, :produto_id, :quantidade)
      end
    end
  end
end