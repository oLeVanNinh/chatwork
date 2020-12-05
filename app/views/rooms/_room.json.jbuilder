json.extract! room, :id, :name, :room_id, :avatar, :room_type, :created_at, :updated_at
json.url room_url(room, format: :json)
