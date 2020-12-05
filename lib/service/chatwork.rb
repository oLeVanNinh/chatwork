require "httparty"
require "nokogiri"

module Service
  class Chatwork
    class << self
      def cookie_string
        Rails.cache.read(:cookie_string)
      end

      def access_token(force_refresh = false)
        begin
          if force_refresh || @token.nil?
            url = "https://www.chatwork.com/"
            response = HTTParty.get(url, { headers: { 'Cookie' => cookie_string }})
            @token = response.to_s.scan(/var\sACCESS_TOKEN\s+=\s'(\w+)'/)[0][0]
          end
          @token
        rescue StandardError => e
          puts e.message
        end
      end

      def current_account_id
        begin
          if @current_account_id.nil?
            url = "https://www.chatwork.com/"
            response = HTTParty.get(url, { headers: { 'Cookie' => cookie_string }})
            @current_account_id = response.to_s.scan(/var\sMYID\s+=\s'(\w+)'/)[0][0]
          end
          @current_account_id
        rescue StandardError => e
          puts e.message
        end
      end

      def send_message(message, room_id)
        url = "https://www.chatwork.com/gateway/send_chat.php?room_id=#{room_id}"
        body = {
          "text": message,
          "_t": access_token
        }

        HTTParty.post(url, body: body, headers: { 'Cookie': cookie_string })
      end

      def sync_room_info
        url = "https://www.chatwork.com/gateway/init_load.php"
        body = {
          "_t": access_token
        }

        response = HTTParty.post(url, body: body, headers: { 'Cookie': cookie_string })

        import_room_data(response) if response.code == 200
      end

      private

      def import_room_data(response)
        room_data = response["result"]["room_dat"]
        contact_data = response["result"]["contact_dat"]
        account_id = current_account_id

        room_data.each do |room_id, room_info|
          room = Room.find_or_initialize_by(room_id: room_id)
          next if room.persisted?
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

          room.attributes = { name: room_name, avatar: room_avatar, room_type: room_type }
          room.save
        end
      end
    end
  end
end
