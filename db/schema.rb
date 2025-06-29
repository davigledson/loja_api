# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_28_165348) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "carrinhos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_carrinhos_on_usuario_id"
  end

  create_table "categoria", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descricao"
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "telefone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enderecos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.string "cep"
    t.string "rua"
    t.string "numero"
    t.string "complemento"
    t.string "cidade"
    t.string "estado"
    t.boolean "principal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_enderecos_on_usuario_id"
  end

  create_table "favoritos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "produto_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_favoritos_on_produto_id"
    t.index ["usuario_id"], name: "index_favoritos_on_usuario_id"
  end

  create_table "imagens_produtos", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.string "url_imagem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_imagens_produtos_on_produto_id"
  end

  create_table "itens_carrinho", force: :cascade do |t|
    t.bigint "carrinho_id", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrinho_id"], name: "index_itens_carrinho_on_carrinho_id"
    t.index ["produto_id"], name: "index_itens_carrinho_on_produto_id"
  end

  create_table "itens_pedido", force: :cascade do |t|
    t.bigint "pedido_id", null: false
    t.bigint "produto_id", null: false
    t.integer "quantidade", default: 1
    t.decimal "preco", precision: 10, scale: 2
    t.decimal "desconto", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_id"], name: "index_itens_pedido_on_pedido_id"
    t.index ["produto_id"], name: "index_itens_pedido_on_produto_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "pedidos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "endereco_id", null: false
    t.string "status", default: "pendente"
    t.string "metodo_pagamento"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endereco_id"], name: "index_pedidos_on_endereco_id"
    t.index ["usuario_id"], name: "index_pedidos_on_usuario_id"
  end

  create_table "produtos", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.decimal "preco"
    t.integer "estoque"
    t.boolean "destaque"
    t.boolean "ativo"
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome"
    t.string "email", null: false
    t.string "senha_digest"
    t.string "papel", default: "cliente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_usuarios_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "carrinhos", "usuarios"
  add_foreign_key "enderecos", "usuarios"
  add_foreign_key "favoritos", "produtos"
  add_foreign_key "favoritos", "usuarios"
  add_foreign_key "imagens_produtos", "produtos"
  add_foreign_key "itens_carrinho", "carrinhos"
  add_foreign_key "itens_carrinho", "produtos"
  add_foreign_key "itens_pedido", "pedidos"
  add_foreign_key "itens_pedido", "produtos"
  add_foreign_key "pedidos", "enderecos"
  add_foreign_key "pedidos", "usuarios"
  add_foreign_key "produtos", "categoria", column: "categoria_id"
end
