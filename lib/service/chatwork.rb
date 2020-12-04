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

      def send_message(message, room_id)
        url = "https://www.chatwork.com/gateway/send_chat.php?room_id=#{room_id}"
        body = {
          "text": message,
          "_t": access_token
        }

        HTTParty.post(url, body: body, headers: { 'Cookie': cookie_string })
      end
    end
  end
end
