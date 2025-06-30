# app/serializers/endereco_serializer.rb
class EnderecoSerializer < ActiveModel::Serializer
  attributes :id, :usuario_id, :cep, :rua, :numero, :complemento, :cidade, :estado, :principal, :created_at, :updated_at
end
