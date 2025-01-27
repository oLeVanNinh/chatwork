class MessageScheduleWorker
  include Sidekiq::Worker

  def perform(message_id)
    begin
      message = Message.find_by(id: message_id)

      return unless message
      response = Service::Chatwork.send_message(message.content, message.room.room_id, message.room.user_id)
      status =  Message.status.fail
      status = Message.status.sended if response.code == 200 && response.parsed_response.is_a?(Hash) && response.parsed_response["status"]["success"] == true
      message.update!(status: status)
    rescue StandardError => e
      Rails.logger.error e.message
    end
  end
end
