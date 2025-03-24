class Game < ApplicationRecord
  belongs_to :admin
  has_many_attached :images
  has_many :images, dependent: :destroy
  has_many :players, dependent: :destroy
end
