# app/controllers/api/v1/produtos_controller.rb
module Api
  module V1
    class ProdutosController < ApplicationController
      # Autenticação para ações que modificam dados (create, update, destroy)
      before_action :authenticate_usuario!, only: [:create, :update, :destroy]
      before_action :set_produto, only: [:show, :update, :destroy]

      # GET /api/v1/produtos
      # Geralmente público para que qualquer um possa ver os produtos
      def index
        render json: Produto.all
      end

      # GET /api/v1/produtos/:id
      # Geralmente público para que qualquer um possa ver os detalhes de um produto
      def show
        render json: @produto
      end

      # POST /api/v1/produtos
      # Requer autenticação
      def create
        produto = Produto.new(produto_params)
        if produto.save
          render json: produto, status: :created
        else
          render json: { errors: produto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/produtos/:id
      # Requer autenticação
      def update
        if @produto.update(produto_params)
          render json: @produto
        else
          render json: { errors: @produto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/produtos/:id
      # Requer autenticação
      def destroy
        @produto.destroy
        head :no_content
      end

      private

      def set_produto
        @produto = Produto.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Produto não encontrado." }, status: :not_found
      end

      def produto_params
        params.require(:produto).permit(:nome, :descricao, :preco, :estoque, :destaque, :ativo, :categoria_id)
      end
    end
  end
end
