class ItensPedido < ApplicationRecord
  self.table_name = "itens_pedido"
   belongs_to :pedido
  belongs_to :produto

  # Validações (exemplo)
  validates :pedido, presence: true
  validates :produto, presence: true
  validates :quantidade, presence: true, numericality: { greater_than: 0 }
  validates :preco, presence: true, numericality: { greater_than_or_equal_to: 0 }
end