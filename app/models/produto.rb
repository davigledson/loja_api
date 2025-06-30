class Produto < ApplicationRecord
  belongs_to :categoria

  has_many :imagens_produtos
   has_many :favoritos, dependent: :destroy 
  has_many :itens_carrinho, dependent: :destroy # Provavelmente também precisa disso
  has_many :itens_pedido, dependent: :destroy # E is

  validates :nome, :preco, presence: true
end