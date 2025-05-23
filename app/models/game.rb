class Game < ApplicationRecord
  belongs_to :admin
  has_many_attached :images
  has_one_attached :logo
  has_one_attached :background_image 
  has_one_attached :backside_image
  has_many :players, dependent: :destroy
end
