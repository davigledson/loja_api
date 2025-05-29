module Api
  module V1
    class ProdutosController < ApplicationController
      before_action :set_produto, only: [:show, :update, :destroy]

      def index
        render json: Produto.all
      end

      def show
        render json: @produto
      end

      def create
        produto = Produto.new(produto_params)
        if produto.save
          render json: produto, status: :created
        else
          render json: { errors: produto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @produto.update(produto_params)
          render json: @produto
        else
          render json: { errors: @produto.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @produto.destroy
        head :no_content
      end

      private

      def set_produto
        @produto = Produto.find(params[:id])
      end

      def produto_params
        params.require(:produto).permit(:nome, :descricao, :preco, :estoque, :destaque, :ativo, :categoria_id)
      end
    end
  end
end
