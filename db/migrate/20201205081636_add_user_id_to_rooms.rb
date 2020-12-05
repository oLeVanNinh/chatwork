class AddUserIdToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :user_id, :string, index: true
  end
end
