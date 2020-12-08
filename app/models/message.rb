# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  content     :text
#  delivery_at :datetime
#  status      :integer          default("unsent")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  job_id      :string
#  room_id     :bigint
#
# Indexes
#
#  index_messages_on_room_id  (room_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#
class Message < ApplicationRecord
  extend Enumerize

  belongs_to :room

  validates :content, presence: true
  validates :delivery_at, presence: true
  validate :deliver_time_in_the_future

  enumerize :status, in: { unsent: 0, sended: 1, fail: 2 }

  before_destroy :destroy_job_schedule

  private

  def destroy_job_schedule
    jobs = Sidekiq::ScheduledSet.new.select { |schuled| schuled.jid == job_id }
    jobs.each(&:delete)
  end

  def deliver_time_in_the_future
    return if delivery_at > Time.now || (persisted? && !delivery_at_changed?)
    errors.add(:delivery_at, "Date cannot set in the past")
  end
end
