class Api::V1::CategoriasController < ApplicationController
  before_action :set_categoria, only: [:show, :update, :destroy]

  # GET /api/v1/categorias
  def index
    @categorias = Categoria.all
    render json: @categorias
  end

  # GET /api/v1/categorias/:id
  def show
    render json: @categoria
  end

  # POST /api/v1/categorias
  def create
    @categoria = Categoria.new(categoria_params)
    if @categoria.save
      render json: @categoria, status: :created
    else
      render json: { errors: @categoria.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/categorias/:id
  def update
    if @categoria.update(categoria_params)
      render json: @categoria
    else
      render json: { errors: @categoria.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/categorias/:id
  def destroy
    @categoria.destroy
    head :no_content
  end

  private

  def set_categoria
    @categoria = Categoria.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Categoria não encontrada' }, status: :not_found
  end

  def categoria_params
      params.require(:categoria).permit(:nome) # ajuste os campos conforme seu model

    #params.require(:categoria).permit(:nome, :descricao) # ajuste os campos conforme seu model
  end
end
