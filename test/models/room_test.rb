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
#  user_id    :string
#
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
