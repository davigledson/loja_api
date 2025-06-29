# app/serializers/produto_serializer.rb
class ProdutoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :descricao, :preco, :estoque, :destaque, :ativo, :categoria_id
end
