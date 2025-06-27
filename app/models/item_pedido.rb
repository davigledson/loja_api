class ItemPedido < ApplicationRecord
  self.table_name = "itens_pedido"
  belongs_to :pedido
  belongs_to :produto
end