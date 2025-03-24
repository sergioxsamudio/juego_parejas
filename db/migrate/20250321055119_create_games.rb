class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :code
      t.string :name
      t.string :header_color
      t.string :text_color
      t.string :background_color
      t.text :start_text
      t.text :during_text
      t.text :end_text
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
