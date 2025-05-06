class AddScoreToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :score, :integer
  end
end
