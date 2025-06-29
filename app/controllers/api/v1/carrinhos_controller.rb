# app/controllers/api/v1/carrinhos_controller.rb
module Api
  module V1
    class CarrinhosController < ApplicationController
      # Garante que o usuário esteja autenticado para todas as ações neste controller
      before_action :authenticate_usuario!
      # Define o carrinho para as ações que precisam dele, com autorização
      before_action :set_carrinho, only: [:show, :update, :destroy, :limpar]

      # GET /api/v1/carrinhos/:id
      # Retorna um carrinho específico (do usuário logado)
      def show
        # set_carrinho já garante que o carrinho pertence ao usuário logado
        render json: @carrinho
      end

      # POST /api/v1/carrinhos
      # Cria um novo carrinho para o usuário logado
      def create
        # Garante que o usuário só pode ter um carrinho
        if current_usuario.carrinho.present? # Verifica se o usuário já possui um carrinho
          render json: { error: "Usuário já possui um carrinho." }, status: :conflict
          return
        end

        # Cria um novo carrinho associado ao usuário logado
        @carrinho = Carrinho.new(usuario: current_usuario)
        if @carrinho.save
          render json: @carrinho, status: :created
        else
          render json: { errors: @carrinho.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/carrinhos/:id
      # Atualiza um carrinho específico (do usuário logado)
      def update
        # set_carrinho já garante que o carrinho pertence ao usuário logado
        if @carrinho.update(carrinho_params)
          render json: @carrinho
        else
          render json: { errors: @carrinho.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/carrinhos/:id
      # Deleta um carrinho específico (do usuário logado)
      def destroy
        # set_carrinho já garante que o carrinho pertence ao usuário logado
        @carrinho.destroy
        head :no_content
      end

      # NOVA AÇÃO: GET /api/v1/carrinhos/usuario/:usuario_id
      # Busca o carrinho do usuário logado pelo seu ID
      def buscar_por_usuario
        # Garante que o usuário só pode buscar o próprio carrinho
        # params[:usuario_id] é o ID passado na URL (ex: /carrinhos/usuario/4)
        if params[:usuario_id].to_i == current_usuario.id
          @carrinho = current_usuario.carrinho # Busca o carrinho associado ao usuário logado
          if @carrinho
            render json: @carrinho
          else
            # Retorna 404 se o carrinho não for encontrado para o usuário logado
            render json: { error: "Carrinho não encontrado para este usuário." }, status: :not_found
          end
        else
          # Retorna 401 se o usuário tentar buscar o carrinho de outro usuário
          render json: { error: "Não autorizado a buscar o carrinho deste usuário." }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound # Caso o current_usuario.id não encontre um usuário
        render json: { error: "Usuário não encontrado." }, status: :not_found
      end

      # NOVA AÇÃO: DELETE /api/v1/carrinhos/:id/limpar
      # Limpa todos os itens de um carrinho específico (do usuário logado)
      def limpar
        # set_carrinho já garante que o carrinho pertence ao usuário logado
        @carrinho.itens_carrinho.destroy_all # Remove todos os itens do carrinho
        head :no_content # Retorna um status 204 (No Content)
      end

      private

      # Define o carrinho e verifica se ele pertence ao usuário logado
      def set_carrinho
        # current_usuario.carrinho assume que o usuário tem um carrinho associado
        # e busca o carrinho do usuário logado.
        @carrinho = current_usuario.carrinho

        # Verifica se o ID do carrinho na URL corresponde ao carrinho do usuário logado
        # Isso é importante para ações como show, update, destroy, limpar
        unless @carrinho && @carrinho.id == params[:id].to_i
          render json: { error: "Carrinho não encontrado ou não pertence ao seu usuário." }, status: :not_found
        end
      rescue ActiveRecord::RecordNotFound # Caso o current_usuario.carrinho não encontre um carrinho
        render json: { error: "Carrinho não encontrado." }, status: :not_found
      end

      # Parâmetros permitidos para um carrinho
      def carrinho_params
        # O carrinho não tem outros atributos que seriam enviados pelo frontend além do usuario_id,
        # que é definido automaticamente pelo current_usuario.
        # Se você tiver outros atributos no modelo Carrinho que o frontend possa enviar, adicione-os aqui.
        params.require(:carrinho).permit()
      end
    end
  end
end
