json.extract! player, :id, :game_id, :first_name, :last_name, :email, :cellphone, :created_at, :updated_at
json.url player_url(player, format: :json)
