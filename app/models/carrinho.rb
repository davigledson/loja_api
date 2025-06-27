class Carrinho < ApplicationRecord
  belongs_to :usuario
  has_many :itens_carrinho, dependent: :destroy
end