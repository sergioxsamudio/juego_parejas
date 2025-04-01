class Player < ApplicationRecord
  belongs_to :game
  attribute :score, :integer, default: 0
end
