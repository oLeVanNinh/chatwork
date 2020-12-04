# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  avatar     :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :string
#
class Room < ApplicationRecord
end
