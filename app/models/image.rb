class Image < ApplicationRecord
  belongs_to :game
  has_one_attached :file
end
