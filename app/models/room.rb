# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  avatar     :string
#  name       :string
#  room_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :string
#
class Room < ApplicationRecord
  extend Enumerize
  validates :room_id, presence: true
  validates :name, presence: true

  enumerize :room_type, in: { group: 1, private: 2 }
end
