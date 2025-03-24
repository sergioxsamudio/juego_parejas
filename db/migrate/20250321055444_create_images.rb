class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images do |t|
      t.references :game, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
