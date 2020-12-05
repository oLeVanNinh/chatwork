class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :room_id
      t.string :avatar
      t.integer :room_type

      t.timestamps
    end
  end
end
