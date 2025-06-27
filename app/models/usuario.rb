class Usuario < ApplicationRecord
  has_secure_password

  has_many :enderecos
  has_many :pedidos
  has_one :carrinho
  has_many :favoritos

  validates :papel, presence: true, inclusion: { in: %w[cliente admin] }

  validates :email, presence: true, uniqueness: true
end
