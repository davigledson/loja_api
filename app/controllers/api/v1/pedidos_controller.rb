# app/controllers/api/v1/pedidos_controller.rb
module Api
  module V1
    class PedidosController < ApplicationController
      before_action :authenticate_usuario! # Garante que o usuário esteja logado
      before_action :set_pedido, only: [:show, :update, :destroy] # Adicione as novas ações aqui
      before_action :authorize_admin_for_all_pedidos, only: [:index, :contar_pedidos, :contar_pedidos_por_status, :faturamento_total, :faturamento_mes_atual, :produtos_mais_vendidos, :vendas_recentes] # Protege ações de dashboard

      # GET /api/v1/pedidos
      def index
        if current_usuario.papel == 'admin'
          @pedidos = Pedido.all.includes(:usuario, :itens_pedido => :produto, :endereco_entrega=>[])
        else
          @pedidos = current_usuario.pedidos.includes(:itens_pedido => :produto, :endereco_entrega=>[])
        end
        render json: @pedidos, include: ['itens_pedido.produto', 'endereco_entrega', 'usuario']
      end

      def index_by_user
        if params[:usuario_id].to_i != current_usuario.id && current_usuario.papel != 'admin'
          render json: { error: "Não autorizado a ver pedidos de outro usuário." }, status: :unauthorized
          return
        end
        
        # Admin pode ver pedidos de qualquer usuário, usuário comum só os seus
        user_id = current_usuario.papel == 'admin' ? params[:usuario_id] : current_usuario.id
        @pedidos = Pedido.where(usuario_id: user_id).includes(:itens_pedido => :produto, :endereco_entrega => [])
        render json: @pedidos, include: ['itens_pedido.produto', 'endereco_entrega']
      end

      # GET /api/v1/pedidos/:id
      def show
        render json: @pedido, include: ['itens_pedido.produto', 'endereco_entrega']
      end

      # POST /api/v1/pedidos
      def create
        @pedido = current_usuario.pedidos.new(pedido_params)

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
        if @pedido.update(pedido_params)
          render json: @pedido
        else
          render json: { errors: @pedido.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/pedidos/:id
      def destroy
        @pedido.destroy
        head :no_content
      end

      # NOVAS AÇÕES PARA O DASHBOARD

      # GET /api/v1/pedidos/contar
      def contar_pedidos
        render json: { count: Pedido.count }
      end

      # GET /api/v1/pedidos/contar_por_status?status=pendente
      def contar_pedidos_por_status
        status = params[:status]
        count = Pedido.where(status: status).count
        render json: { count: count }
      end

      # GET /api/v1/pedidos/faturamento_total
      def faturamento_total
        total_revenue = Pedido.sum(:total)
        render json: { total_revenue: total_revenue }
      end

      # GET /api/v1/pedidos/faturamento_mes_atual
      def faturamento_mes_atual
        start_of_month = Time.zone.now.beginning_of_month
        end_of_month = Time.zone.now.end_of_month
        monthly_revenue = Pedido.where(created_at: start_of_month..end_of_month).sum(:total)
        render json: { monthly_revenue: monthly_revenue }
      end

      # GET /api/v1/pedidos/produtos_mais_vendidos
      def produtos_mais_vendidos
        # Isso é um exemplo básico. Para um relatório mais robusto, considere:
        # - Agrupar por produto_id e somar quantidade
        # - Incluir nome do produto e categoria
        # - Limitar o número de resultados
        top_products = ItensPedido.group(:produto_id)
                                 .select('produto_id, SUM(quantidade) as total_vendido')
                                 .order('total_vendido DESC')
                                 .limit(5)
        
        # Incluir detalhes do produto
        products_with_details = top_products.map do |item|
          product = Produto.find_by(id: item.produto_id)
          {
            id: product.id,
            nome: product.nome,
            total_vendido: item.total_vendido,
            categoria: product.categoria # Assumindo que Produto tem belongs_to :categoria
          } if product
        end.compact # Remove nulos se algum produto não for encontrado

        render json: products_with_details
      end

      # GET /api/v1/pedidos/vendas_recentes
      def vendas_recentes
        # Isso é um exemplo. Adapte para o que você considera "vendas recentes"
        # Pode ser os últimos 5 pedidos, ou pedidos do último dia, etc.
        recent_orders = Pedido.order(created_at: :desc).limit(5)
        
        recent_sales_data = recent_orders.map do |pedido|
          {
            id: pedido.id,
            cliente: pedido.usuario&.nome || pedido.usuario&.email, # Pega nome ou email do usuário
            produto: pedido.itens_pedido.map { |item| item.produto&.nome }.compact.join(', '), # Nomes dos produtos no pedido
            valor: pedido.total,
            data: pedido.created_at
          }
        end

        render json: recent_sales_data
      end

      private

      # NOVO: before_action para proteger ações do dashboard para admin
      def authorize_admin_for_all_pedidos
        unless current_usuario.papel == 'admin'
          render json: { error: "Acesso não autorizado. Apenas administradores podem ver este relatório." }, status: :unauthorized
        end
      end

      def set_pedido
        if current_usuario.papel == 'admin'
          @pedido = Pedido.find(params[:id])
        else
          @pedido = current_usuario.pedidos.find(params[:id])
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Pedido não encontrado ou você não tem permissão para acessá-lo." }, status: :not_found
      end

      def pedido_params
        params.require(:pedido).permit(
          :endereco_entrega_id, :metodo_pagamento, :total, :status, # Adicione :total e :status se forem atualizáveis por admin
          itens_pedido_attributes: [:produto_id, :quantidade, :preco, :desconto]
        )
      end
    end
  end
end
