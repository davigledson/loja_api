class CreateProdutos < ActiveRecord::Migration[8.0]
  def change
    create_table :produtos do |t|
      t.string :nome
      t.text :descricao
      t.decimal :preco
      t.integer :estoque
      t.boolean :destaque
      t.boolean :ativo
      t.references :categoria, null: false, foreign_key: true

      t.timestamps
    end
  end
end
