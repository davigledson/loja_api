# app/controllers/api/v1/pedidos_controller.rb
module Api
  module V1
    class PedidosController < ApplicationController
      before_action :authenticate_usuario! # Garante que o usuário esteja logado
      before_action :set_pedido, only: [:show, :update, :destroy]

      # GET /api/v1/pedidos
      def index
        # Apenas pedidos do usuário logado
        @pedidos = current_usuario.pedidos.includes(:itens_pedido, :endereco_entrega)
        render json: @pedidos, include: ['itens_pedido.produto', 'endereco_entrega']
      end
      def index_by_user
        # Garante que o usuário só pode ver seus próprios pedidos
        if params[:usuario_id].to_i != current_usuario.id
          render json: { error: "Não autorizado a ver pedidos de outro usuário." }, status: :unauthorized
          return
        end
        
        @pedidos = current_usuario.pedidos.includes(:itens_pedido => :produto, :endereco_entrega => [])
        render json: @pedidos, include: ['itens_pedido.produto', 'endereco_entrega']
      end

      # GET /api/v1/pedidos/:id
      def show
        # set_pedido já garante que o pedido pertence ao usuário logado
        render json: @pedido, include: ['itens_pedido.produto', 'endereco_entrega']
      end


      # POST /api/v1/pedidos
      def create
        # Cria o pedido associado ao usuário logado
        @pedido = current_usuario.pedidos.new(pedido_params)

        # Valida se o endereco_entrega_id pertence ao usuário logado
        unless current_usuario.enderecos.exists?(id: @pedido.endereco_entrega_id)
          render json: { error: "Endereço de entrega inválido ou não pertence ao seu usuário." }, status: :unprocessable_entity
          return
        end

        if @pedido.save
          # Opcional: Limpar o carrinho do usuário após a criação do pedido
          # current_usuario.carrinho.itens_carrinho.destroy_all if current_usuario.carrinho.present?
          render json: @pedido, status: :created, include: ['itens_pedido.produto', 'endereco_entrega']
        else
          render json: { errors: @pedido.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/pedidos/:id
      def update
        # set_pedido já garante que o pedido pertence ao usuário logado
        if @pedido.update(pedido_params)
          render json: @pedido
        else
          render json: { errors: @pedido.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/pedidos/:id
      def destroy
        # set_pedido já garante que o pedido pertence ao usuário logado
        @pedido.destroy
        head :no_content
      end

      private

      def set_pedido
        # Busca o pedido pelo ID e garante que ele pertence ao usuário logado
        @pedido = current_usuario.pedidos.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Pedido não encontrado ou não pertence ao seu usuário." }, status: :not_found
      end

      def pedido_params
        params.require(:pedido).permit(
          :endereco_entrega_id,
          # Permite atributos aninhados para itens_pedido
          itens_pedido_attributes: [:produto_id, :quantidade, :preco]
        )
      end
    end
  end
end
