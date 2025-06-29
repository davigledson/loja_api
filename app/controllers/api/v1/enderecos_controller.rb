# app/controllers/api/v1/enderecos_controller.rb
module Api
  module V1
    class EnderecosController < ApplicationController
      # Garante que o usuário esteja autenticado para acessar estas ações
      before_action :authenticate_usuario! # Assumindo que você tem este método do Devise ou similar

      
      before_action :set_endereco, only: [:show, :update, :destroy, :set_principal]

      # GET /api/v1/enderecos
     
      def index
        render json: Endereco.all
      end

      # GET /api/v1/enderecos/:id
      def show
        # Garante que o usuário só possa ver seu próprio endereço, a menos que seja admin
        if @endereco.usuario_id == current_usuario.id || current_usuario.papel == 'admin'
          render json: @endereco
        else
          render json: { error: "Não autorizado a visualizar este endereço." }, status: :unauthorized
        end
      end

      # POST /api/v1/enderecos
      def create
        @endereco = Endereco.new(endereco_params)
        # Define o usuario_id automaticamente para o usuário logado por segurança
        @endereco.usuario_id = current_usuario.id

        if @endereco.save
          render json: @endereco, status: :created
        else
          render json: { errors: @endereco.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/enderecos/:id
      def update
        # Garante que o usuário só possa atualizar seu próprio endereço, a menos que seja admin
        if @endereco.usuario_id == current_usuario.id || current_usuario.papel == 'admin'
          if @endereco.update(endereco_params)
            render json: @endereco
          else
            render json: { errors: @endereco.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Não autorizado a atualizar este endereço." }, status: :unauthorized
        end
      end

      # DELETE /api/v1/enderecos/:id
      def destroy
        # Garante que o usuário só possa deletar seu próprio endereço, a menos que seja admin
        if @endereco.usuario_id == current_usuario.id || current_usuario.papel == 'admin'
          @endereco.destroy
          head :no_content
        else
          render json: { error: "Não autorizado a deletar este endereço." }, status: :unauthorized
        end
      end

      # NOVA AÇÃO: GET /api/v1/enderecos/usuario/:usuario_id
      def index_by_user
        # Garante que o usuário logado só possa ver seus próprios endereços
        # ou endereços de outros usuários se for um admin.
        target_user_id = params[:usuario_id].to_i

        if target_user_id == current_usuario.id || current_usuario.papel == 'admin'
          @enderecos = Endereco.where(usuario_id: target_user_id).order(created_at: :desc)
          render json: @enderecos
        else
          render json: { error: "Não autorizado a visualizar endereços deste usuário." }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound # Caso o usuário_id não exista
        render json: { error: "Usuário não encontrado." }, status: :not_found
      end

      # NOVA AÇÃO: PATCH /api/v1/enderecos/:id/principal
      def set_principal
        # Garante que o usuário só possa definir seu próprio endereço como principal, a menos que seja admin
        if @endereco.usuario_id == current_usuario.id || current_usuario.papel == 'admin'
          Endereco.transaction do
            # Desmarca todos os outros endereços do usuário como principais
            Endereco.where(usuario_id: @endereco.usuario_id, principal: true).update_all(principal: false)
            # Define o endereço atual como principal
            @endereco.update!(principal: true)
          end
          render json: @endereco
        else
          render json: { error: "Não autorizado a definir este endereço como principal." }, status: :unauthorized
        end
      rescue => e # Captura erros de banco de dados ou outros
        render json: { error: e.message }, status: :unprocessable_entity
      end


      private

      def set_endereco
        @endereco = Endereco.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Endereço não encontrado." }, status: :not_found
      end

      def endereco_params
        # Remove :usuario_id dos parâmetros permitidos, pois ele é definido pelo current_usuario.id
        # Isso impede que um usuário mal-intencionado tente criar/atualizar um endereço para outro usuário.
        params.require(:endereco).permit(:cep, :rua, :numero, :complemento, :cidade, :estado, :principal)
      end
    end
  end
end
