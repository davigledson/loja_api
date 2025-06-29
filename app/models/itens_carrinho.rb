class ItensCarrinho < ApplicationRecord
  self.table_name = "itens_carrinho"
  belongs_to :carrinho
  belongs_to :produto
end