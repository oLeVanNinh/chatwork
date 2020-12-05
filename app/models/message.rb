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

  enumerize :status, in: { unsent: 0, sended: 1, fail: 2 }
end
