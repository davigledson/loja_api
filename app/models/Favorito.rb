class Favorito < ApplicationRecord
  belongs_to :usuario
  belongs_to :produto
end