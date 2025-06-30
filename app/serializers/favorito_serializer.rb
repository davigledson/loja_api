# app/serializers/favorito_serializer.rb
class FavoritoSerializer < ActiveModel::Serializer
  attributes :id, :usuario_id, :produto_id, :created_at, :updated_at

  belongs_to :produto # Inclui os detalhes do produto associado
end
