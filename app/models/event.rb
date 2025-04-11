class Event < ApplicationRecord
  enum :status, {
    pending: 0,
    processed: 1,
    failed: 2,
  }, default: :pending

  validates :identifier, presence: true
  validates :name, presence: true
  validates :payload, presence: true
  validates :timestamp, presence: true
  validates :status, presence: true
end
