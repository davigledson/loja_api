class ItemCarrinhoSerializer < ActiveModel::Serializer
 attributes :id, :carrinho_id, :produto_id, :quantidade, :created_at, :updated_at

  # Associa o produto ao item do carrinho
  belongs_to :produto
end
