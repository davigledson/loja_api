# app/controllers/api/v1/itens_carrinho_controller.rb
module Api
  module V1
    class ItensCarrinhoController < ApplicationController
      # Garante que o usuário esteja autenticado para todas as ações neste controller
      before_action :authenticate_usuario!
      # Define o item do carrinho para as ações que precisam dele, com autorização
      before_action :set_item, only: [:show, :update, :destroy]
      # Define o carrinho do usuário logado para as ações que precisam dele
      before_action :set_user_cart, only: [:create, :index_by_cart]

      # GET /api/v1/itens_carrinho/:id
      # Retorna um item específico do carrinho (com detalhes do produto)
      def show
        # set_item já garante que o item pertence ao usuário logado
        render json: @item, include: :produto # Inclui os detalhes do produto via serializer
      end

      # POST /api/v1/itens_carrinho
      # Adiciona um novo item ao carrinho ou incrementa a quantidade de um item existente
      def create
        # Busca um item existente no carrinho do usuário para o produto_id fornecido
        item = @user_cart.itens_carrinho.find_by(produto_id: item_params[:produto_id])

        if item
          # Se o item já existe, incrementa a quantidade
          item.quantidade += (item_params[:quantidade] || 1).to_i
        else
          # Se o item não existe, cria um novo item para o carrinho do usuário
          item = @user_cart.itens_carrinho.new(item_params)
          item.quantidade ||= 1 # Garante que a quantidade seja pelo menos 1 se não for fornecida
        end

        if item.save
          render json: item, include: :produto, status: :created # Inclui os detalhes do produto
        else
          render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/itens_carrinho/:id
      # Atualiza a quantidade de um item específico no carrinho
      def update
        # set_item já garante que o item pertence ao usuário logado
        if @item.update(item_params)
          render json: @item, include: :produto # Inclui os detalhes do produto
        else
          render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/itens_carrinho/:id
      # Remove um item específico do carrinho
      def destroy
        # set_item já garante que o item pertence ao usuário logado
        @item.destroy
        head :no_content # Retorna um status 204 (No Content)
      end

      # NOVA AÇÃO: GET /api/v1/itens_carrinho/carrinho/:carrinho_id
      # Lista todos os itens de um carrinho específico (do usuário logado)
      def index_by_cart
        # set_user_cart já garante que o carrinho pertence ao usuário logado
        # Carrega os itens do carrinho e seus produtos associados para evitar N+1 queries
        @itens = @user_cart.itens_carrinho.includes(:produto)
        render json: @itens, include: :produto # Garante que o serializer inclua o produto
      end

      private

      # Define o item do carrinho e verifica se ele pertence ao carrinho do usuário logado
      def set_item
        # current_usuario.carrinho assume que o usuário tem um carrinho associado
        # e busca o item dentro desse carrinho.
        @item = current_usuario.carrinho.itens_carrinho.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Item do carrinho não encontrado ou não pertence ao seu carrinho." }, status: :not_found
      end

      # Define o carrinho do usuário logado
      def set_user_cart
        @user_cart = current_usuario.carrinho # Assume que current_usuario.carrinho retorna o objeto Carrinho
        # Se o carrinho não existir, pode ser necessário criá-lo aqui ou no CarrinhosController
        unless @user_cart
          render json: { error: "Carrinho não encontrado para o usuário logado." }, status: :not_found
        end
      end

      # Parâmetros permitidos para um item do carrinho
      def item_params
        # Remove :carrinho_id dos parâmetros permitidos, pois ele é definido pelo set_user_cart
        # Isso impede que um usuário mal-intencionado tente adicionar itens a outro carrinho.
        params.require(:item_carrinho).permit(:produto_id, :quantidade)
      end
    end
  end
end
