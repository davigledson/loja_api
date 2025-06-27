class Produto < ApplicationRecord
  belongs_to :categoria

  has_many :imagens_produtos
  has_many :itens_pedido
  has_many :favoritos

  validates :nome, :preco, presence: true
end