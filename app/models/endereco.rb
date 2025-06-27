class Endereco < ApplicationRecord
  belongs_to :usuario

  validates :cep, :rua, :numero, :cidade, :estado, presence: true
end