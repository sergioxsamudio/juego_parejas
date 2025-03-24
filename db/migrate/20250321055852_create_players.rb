class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :game, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :cellphone

      t.timestamps
    end
  end
end
