json.extract! game, :id, :code, :name, :header_color, :text_color, :background_color, :start_text, :during_text, :end_text, :admin_id, :created_at, :updated_at
json.url game_url(game, format: :json)
