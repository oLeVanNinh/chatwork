require "httparty"
require "nokogiri"

module Service
  class Chatwork
    extend Service::Redis

    class << self
      def cookie_string
        Rails.cache.read(:cookie_string)
      end

      def access_token(force_refresh = false, account_id = nil)
        cookie = account_id.present? ? cookie_info(account_id) : cookie_string
        begin
          if force_refresh || @token.nil?
            url = "https://www.chatwork.com/"
            response = HTTParty.get(url, { headers: { 'Cookie' => cookie }})
            @token = response.to_s.scan(/var\sACCESS_TOKEN\s+=\s'(\w+)'/)[0][0]
          end
          @token
        rescue StandardError => e
          puts e.message
        end
      end

      def current_account_id(force_refresh = false)
        begin
          if @current_account_id.nil? || force_refresh
            url = "https://www.chatwork.com/"
            response = HTTParty.get(url, { headers: { 'Cookie' => cookie_string }})
            @current_account_id = response.to_s.scan(/var\sMYID\s+=\s'(\w+)'/)[0][0]
          end
          @current_account_id
        rescue StandardError => e
          puts e.message
        end
      end

      def send_message(message, room_id, account_id)
        cookie = cookie_info(account_id)
        url = "https://www.chatwork.com/gateway/send_chat.php?room_id=#{room_id}"
        body = {
          "text": message,
          "_t": access_token(true, account_id)
        }

        HTTParty.post(url, body: body, headers: { 'Cookie': cookie })
      end

      def get_init_info
        url = "https://www.chatwork.com/gateway/init_load.php"
        body = {
          "_t": access_token(true)
        }

        HTTParty.post(url, body: body, headers: { 'Cookie': cookie_string })
      end

      def store_cookie_info
        Rails.cache.write("cookie:#{current_account_id(true)}", cookie_string)
      end

      def cookie_info(account_id)
        Rails.cache.read("cookie:#{account_id}")
      end

      def current_user_name
        Rails.cache.read(current_account_id)
      end
    end
  end
end
