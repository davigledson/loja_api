class AddDescricaoToCategorias < ActiveRecord::Migration[8.0]
  def change
    add_column :categoria, :descricao, :text
  end
end
