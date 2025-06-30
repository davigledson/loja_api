class UsuarioSerializer < ActiveModel::Serializer
  attributes :id, :nome, :email, :papel # Inclua todos os campos que você precisa
  # Se 'telefone' não for um campo no seu modelo Usuario, remova-o daqui.
end