# app/serializers/pedido_serializer.rb
class PedidoSerializer < ActiveModel::Serializer
  attributes :id, :usuario_id, :status, :total, :endereco_entrega_id, :created_at, :updated_at

  has_many :itens_pedido # Inclui os itens do pedido
  belongs_to :endereco_entrega # Inclui o endereço de entrega
end
