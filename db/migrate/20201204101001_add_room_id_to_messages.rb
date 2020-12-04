class AddRoomIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :room, foreign_key: true
  end
end
