class CreateEcommerceTables < ActiveRecord::Migration[7.0]
  def change
    # Usuários
    create_table :usuarios do |t|
      t.string :nome
      t.string :email, null: false
      t.string :senha_digest
      t.string :papel, default: "cliente"

      t.timestamps
    end
    add_index :usuarios, :email, unique: true

    # Imagens dos produtos (se não for usar ActiveStorage diretamente)
    create_table :imagens_produtos do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.string :url_imagem

      t.timestamps
    end

    # Favoritos
    create_table :favoritos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true

      t.timestamps
    end

    # Carrinhos
    create_table :carrinhos do |t|
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end

    create_table :itens_carrinho do |t|
      t.references :carrinho, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade, default: 1

      t.timestamps
    end

    # Endereços
    create_table :enderecos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :cep
      t.string :rua
      t.string :numero
      t.string :complemento
      t.string :cidade
      t.string :estado
      t.boolean :principal, default: false

      t.timestamps
    end

    # Pedidos
    create_table :pedidos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :endereco, null: false, foreign_key: true
      t.string :status, default: "pendente"
      t.string :metodo_pagamento
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end

    # Itens do Pedido
    create_table :itens_pedido do |t|
      t.references :pedido, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.integer :quantidade, default: 1
      t.decimal :preco, precision: 10, scale: 2
      t.decimal :desconto, precision: 10, scale: 2

      t.timestamps
    end
  end
end
