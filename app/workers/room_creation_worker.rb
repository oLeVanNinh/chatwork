class RoomCreationWorker
  include Sidekiq::Worker
  include Service::Redis

  def perform
    response = Service::Chatwork.get_init_info
    import_room_data(response) if response.code == 200
  end

  private

  def import_room_data(response)
    room_data = response["result"]["room_dat"]
    contact_data = response["result"]["contact_dat"]
    account_id = Service::Chatwork.current_account_id(force_refresh = true)

    Rails.cache.write(account_id, contact_data[account_id]["name"])

    lock("import_info:#{account_id}") do
      exists_room_ids = Room.where(room_id: room_data.keys)
      (room_data.keys - exists_room_ids).each do |room_id|
        lock("room_import:#{room_id}") do
          room = Room.find_or_initialize_by(room_id: room_id)
          next if room.persisted?
          room_info = room_data[room_id]
          # Room name not exist meaing that this is private contact, so get info from contact info intead of room
          room_type = room_info["n"].present? ? Room.room_type.group : Room.room_type.private
          room_name = room_info["n"]
          room_avatar = room_info["ic"]

          # If is private check, check if that room is own chat room or with other, if with other, get info from them
          unless room_name
            user_info_id = room_info["m"].keys.reject{ |user_id| user_id == account_id }.first || account_id
            room_name = contact_data[user_info_id]["name"]
            room_avatar ||= contact_data[user_info_id]["av"]
          end

          room.attributes = { name: room_name, avatar: room_avatar, room_type: room_type, user_id: account_id }
          room.save!
        end
      end
    end
  end
end
