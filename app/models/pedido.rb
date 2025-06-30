# app/models/pedido.rb
class Pedido < ApplicationRecord
  belongs_to :usuario
  belongs_to :endereco_entrega, class_name: 'Endereco', foreign_key: 'endereco_entrega_id'
  has_many :itens_pedido, dependent: :destroy # Se um pedido é deletado, seus itens também são
  
  # Aceita atributos aninhados para itens_pedido
  accepts_nested_attributes_for :itens_pedido, allow_destroy: true

  # Validações (exemplo)
  validates :usuario, presence: true
  validates :endereco_entrega, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  # Callback para calcular o total antes de salvar
  before_validation :calcular_total_pedido

  private

  def calcular_total_pedido
    self.total = itens_pedido.sum { |item| item.quantidade * item.preco }
  end
end
