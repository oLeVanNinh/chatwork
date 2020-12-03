class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.datetime :delivery_at

      t.timestamps
    end
  end
end
