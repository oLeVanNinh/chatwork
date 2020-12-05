class AddJobIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :job_id, :string
  end
end
