class Message < ApplicationRecord
  validates :content, presence: true
  validates :delivery_at, presence: true
end
