# app/serializers/item_pedido_serializer.rb
class ItemPedidoSerializer < ActiveModel::Serializer
  attributes :id, :pedido_id, :produto_id, :quantidade, :preco_unitario

  belongs_to :produto # Inclui os detalhes do produto associado
end
