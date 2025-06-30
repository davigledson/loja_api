# app/controllers/api/v1/itens_pedido_controller.rb
# Este controller pode ser opcional se itens_pedido são sempre gerenciados via Pedido
module Api
  module V1
    class ItensPedidoController < ApplicationController
      before_action :authenticate_usuario! # Garante que o usuário esteja logado
      before_action :set_item_pedido, only: [:show, :update, :destroy]

      # GET /api/v1/itens_pedido
      def index
        # Retorna itens de pedido do usuário logado (opcional, pode ser via Pedido)
        @itens_pedido = current_usuario.pedidos.flat_map(&:itens_pedido)
        render json: @itens_pedido, include: :produto
      end

      # GET /api/v1/itens_pedido/:id
      def show
        render json: @item_pedido, include: :produto
      end

      # POST /api/v1/itens_pedido (se precisar criar itens de pedido diretamente)
      # def create
      #   @item_pedido = ItemPedido.new(item_pedido_params)
      #   if @item_pedido.save
      #     render json: @item_pedido, status: :created
      #   else
      #     render json: { errors: @item_pedido.errors.full_messages }, status: :unprocessable_entity
      #   end
      # end

      # ... (update, destroy se necessário)

      private

      def set_item_pedido
        # Garante que o item de pedido pertence ao usuário logado
        @item_pedido = current_usuario.pedidos.flat_map(&:itens_pedido).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Item de pedido não encontrado ou não pertence ao seu usuário." }, status: :not_found
      end

      def item_pedido_params
        params.require(:item_pedido).permit(:pedido_id, :produto_id, :quantidade, :preco_unitario)
      end
    end
  end
end
