require "httparty"
require "nokogiri"

module Service
  class Chatwork
    def cookie
      cookie_obj = {
        auto_logindefault: "5d02630c2b614db51ef73c4cd12e44b11ae564c6",
        cwssid: "bn1qh4j2bamqfpslfre8v0u0aj",
        hubspotutk: "7f5b2e956b2ecaefc8cbffec0fc3df05",
        __cfduid: "dc9354970ad52b6e28ff9d1cdef80336d1605180201",
        __hssrc: "1",
        __hstc: "21855972.7f5b2e956b2ecaefc8cbffec0fc3df05.1603939416658.1606983835663.1606986596994.145",
        _fbp: "fb.1.1603798563323.330361322",
        _ga: "GA1.3.1949408019.1603798563",
        _gcl_au: "1.1.93199975.1603798563",
        _gid: "GA1.2.199854254.1606703592",
        _mkto_trk: "id:955-DIQ-169&token:_mch-chatwork.com-1603845150485-39501",
        _mkto_trk_http: "id:955-DIQ-169&token:_mch-chatwork.com-1603845150485-39501",
        _td: "941b3178-74a7-4c2a-8c16-8c62d1fc487e",
      }

      cookie_hash = HTTParty::CookieHash.new
      cookie.each { |k, v| cookie_hash[k] = v }
      cookie_hash
    end

    def access_token(force_refresh = false)
      begin
        url = "https://www.chatwork.com/"
        response = HTTParty.get(url, { headers: { 'Cookie' => cookie.to_cookie_string }})
        @token = response.to_s.scan(/var\sACCESS_TOKEN\s+=\s'(\w+)'/)[0][0]
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

      HTTParty.post(url, body: body, headers: { 'Cookie': cookie.to_cookie_string })
    end
  end
end
