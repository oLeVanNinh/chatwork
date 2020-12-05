class MessageScheduleWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find_by(id: message_id)

    return unless message
    response = Service::Chatwork.send_message(message.content, message.room.room_id)
    status = response.code == 200 ? Message.status.sended : Message.status.fail
    message.update(status: status)
  end
end
