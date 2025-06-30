# app/controllers/api/v1/favoritos_controller.rb
class Api::V1::FavoritosController < ApplicationController
  before_action :authenticate_usuario! # Garante que o usuário esteja logado
  before_action :set_favorito, only: [:destroy] # Apenas para destroy, pois create e index_by_user não precisam de um favorito pré-existente

  # GET /api/v1/favoritos/usuario/:usuario_id
  def index_by_user
    # Garante que o usuário só pode ver seus próprios favoritos
    if params[:usuario_id].to_i != current_usuario.id
      render json: { error: "Não autorizado a ver favoritos de outro usuário." }, status: :unauthorized
      return
    end
    
    @favoritos = current_usuario.favoritos.includes(:produto) # Inclui os detalhes do produto
    render json: @favoritos, include: :produto
  end

  # POST /api/v1/favoritos
  # Adiciona um produto aos favoritos
  def create
    # Verifica se o produto já é favorito para evitar duplicatas
    @favorito = current_usuario.favoritos.find_by(produto_id: favorito_params[:produto_id])

    if @favorito
      render json: { error: "Produto já está nos favoritos." }, status: :conflict # 409 Conflict
    else
      @favorito = current_usuario.favoritos.new(favorito_params)
      if @favorito.save
        render json: @favorito, status: :created, include: :produto
      else
        render json: { errors: @favorito.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # DELETE /api/v1/favoritos/:id
  # Remove um produto dos favoritos
  def destroy
    # set_favorito já garante que o favorito pertence ao usuário logado
    @favorito.destroy
    head :no_content # 204 No Content
  end

  # Opcional: GET /api/v1/favoritos/:id/is_favorite
  # Verifica se um produto específico é favorito para o usuário logado
  # def is_favorite
  #   @favorito = current_usuario.favoritos.find_by(produto_id: params[:id])
  #   render json: { is_favorite: @favorito.present? }
  # end

  private

  def set_favorito
    # Busca o favorito pelo ID e garante que ele pertence ao usuário logado
    @favorito = current_usuario.favoritos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Favorito não encontrado ou não pertence ao seu usuário." }, status: :not_found
  end

  def favorito_params
    params.require(:favorito).permit(:produto_id)
  end
end
