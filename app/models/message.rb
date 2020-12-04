# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  content     :text
#  delivery_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Message < ApplicationRecord
  validates :content, presence: true
  validates :delivery_at, presence: true
end
