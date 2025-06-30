# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts 'Criando produtos...'

produtos = [
  {
    nome: "Samambaia Amazônica",
    descricao: "Planta ornamental ideal para ambientes internos, requer luz indireta e rega moderada.",
    preco: 50.0,
    estoque: 150,
    destaque: true,
    ativo: true,
    categoria_id: 3
  },
  {
    nome: "Cacto Bola",
    descricao: "Planta suculenta resistente, perfeita para locais ensolarados e pouca rega.",
    preco: 35.0,
    estoque: 100,
    destaque: false,
    ativo: true,
    categoria_id: 3
  },
  {
    nome: "Paz-de-Espírito",
    descricao: "Planta com flores brancas elegantes, ideal para ambientes internos com pouca luz.",
    preco: 60.0,
    estoque: 80,
    destaque: true,
    ativo: true,
    categoria_id: 3
  },
  {
    nome: "Regador Metálico",
    descricao: "Regador resistente com capacidade de 2 litros, ideal para jardinagem doméstica.",
    preco: 45.0,
    estoque: 40,
    destaque: false,
    ativo: true,
    categoria_id: 2
  },
  {
    nome: "Pá de Jardim",
    descricao: "Ferramenta essencial para escavações em pequenos vasos e canteiros.",
    preco: 25.0,
    estoque: 60,
    destaque: false,
    ativo: true,
    categoria_id: 2
  },
  {
    nome: "Orquídea Phalaenopsis",
    descricao: "Planta elegante com flores duradouras, ótima para presentear.",
    preco: 80.0,
    estoque: 50,
    destaque: true,
    ativo: true,
    categoria_id: 3
  },
  {
    nome: "Tesoura de Poda Profissional",
    descricao: "Tesoura afiada com cabo ergonômico para podas de precisão.",
    preco: 70.0,
    estoque: 30,
    destaque: false,
    ativo: true,
    categoria_id: 2
  },
  {
    nome: "Adubo Orgânico",
    descricao: "Fertilizante natural para melhorar o crescimento e a saúde das plantas.",
    preco: 20.0,
    estoque: 100,
    destaque: false,
    ativo: true,
    categoria_id: 4
  },
  {
    nome: "Mini Jardim Suculentas",
    descricao: "Conjunto decorativo com diversas suculentas em vaso de cerâmica.",
    preco: 90.0,
    estoque: 25,
    destaque: true,
    ativo: true,
    categoria_id: 3
  },
  {
    nome: "Mangueira Flexível 10m",
    descricao: "Mangueira leve e resistente para irrigação de jardins pequenos.",
    preco: 55.0,
    estoque: 35,
    destaque: false,
    ativo: true,
    categoria_id: 2
  }
]

Produto.insert_all!(produtos)

puts 'Produtos criados com sucesso!'

