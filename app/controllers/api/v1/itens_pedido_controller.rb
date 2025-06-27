module Api
  module V1
    class ItensPedidoController < ApplicationController
      before_action :set_item, only: [:show, :update, :destroy]

      def index
        render json: ItemPedido.all
      end

      def show
        render json: @item
      end

      def create
        item = ItemPedido.new(item_params)
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
        @item = ItemPedido.find(params[:id])
      end

      def item_params
        params.require(:item_pedido).permit(:pedido_id, :produto_id, :quantidade, :preco, :desconto)
      end
    end
  end
end