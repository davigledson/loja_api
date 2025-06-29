class Usuario < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :enderecos
  has_many :pedidos
  has_one :carrinho
  has_many :favoritos

  validates :papel, presence: true, inclusion: { in: %w[cliente admin] }
  validates :email, presence: true, uniqueness: true

  # Métodos para verificar papel do usuário
  def admin?
    papel == 'admin'
  end

  def cliente?
    papel == 'cliente'
  end

  # Método necessário para o devise-jwt
  def jwt_subject
    id
  end
end