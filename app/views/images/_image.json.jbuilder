json.extract! image, :id, :game_id, :image_url, :created_at, :updated_at
json.url image_url(image, format: :json)
