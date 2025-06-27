module Api
  module V1
    class EnderecosController < ApplicationController
      before_action :set_endereco, only: [:show, :update, :destroy]

      def index
        render json: Endereco.all
      end

      def show
        render json: @endereco
      end

      def create
        endereco = Endereco.new(endereco_params)
        if endereco.save
          render json: endereco, status: :created
        else
          render json: { errors: endereco.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @endereco.update(endereco_params)
          render json: @endereco
        else
          render json: { errors: @endereco.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @endereco.destroy
        head :no_content
      end

      private

      def set_endereco
        @endereco = Endereco.find(params[:id])
      end

      def endereco_params
        params.require(:endereco).permit(:usuario_id, :cep, :rua, :numero, :complemento, :cidade, :estado, :principal)
      end
    end
  end
end