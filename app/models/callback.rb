# frozen_string_literal: true

class Callback < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :timeout_in_seconds, numericality: { greater_than: 0, less_than_or_equal_to: 20, only_integer: true },
 allow_nil: true

  validate :validate_active_requirements

  scope :active, -> { where(active: true) }

private

  def validate_active_requirements
    return unless active?

    if url.blank?
      errors.add(:active, "cannot be enabled without a URL")
    end

    if timeout_in_seconds.blank?
      errors.add(:active, "cannot be enabled without a timeout")
    end
  end
end
