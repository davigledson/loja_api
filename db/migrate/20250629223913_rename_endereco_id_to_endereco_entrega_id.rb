class RenameEnderecoIdToEnderecoEntregaId < ActiveRecord::Migration[8.0]
  def change
      rename_column :pedidos, :endereco_id, :endereco_entrega_id
  end
end
