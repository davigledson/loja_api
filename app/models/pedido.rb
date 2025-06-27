class Pedido < ApplicationRecord
  belongs_to :usuario
  belongs_to :endereco
  has_many :itens_pedido, dependent: :destroy
end