class WebhookEventJob < ApplicationJob
  queue_as :webhook_events

  # Retry with exponential backoff (2^n seconds) up to 5 attempts.
  retry_on StandardError, attempts: 5, wait: ->(executions) { (2**executions).seconds }

  # Ensure idempotency for deserialization errors
  discard_on ActiveJob::DeserializationError

  class << self
    def event_type
      EventHandler::EVENT_HANDLERS.key(self)
    end
  end

  def perform(payload)
    @payload = payload
    @event_type = self.class.event_type
    @company = find_company
    ActiveRecord::Base.transaction do
      process_webhook
    end

    Rails.logger.info("Successfully processed #{self.class.name} for company #{@company&.id}, event: #{@event_type}")
  rescue StandardError => e
    Rails.logger.error(
      "Error processing #{self.class.name} for company #{@company&.id}, " \
      "event: #{@event_type}: #{e.message}"
    )
    raise e
  end

  # To be implemented by subclasses
  def process_webhook
    raise NotImplementedError, "#{self.class.name} must implement #process_webhook"
  end

  # Protected accessors for subclasses
protected

  # Get the payload from the webhook
  def get_payload
    @payload
  end

  # Get the company associated with this webhook event
  def get_company
    @company
  end

  # Get the event type for this webhook
  def get_event_type
    @event_type
  end

private

  def validate_payload_keys(*required_keys)
    missing_keys = required_keys - @payload.keys
    if missing_keys.any?
      Rails.logger.error("Missing required payload keys: #{missing_keys.join(', ')}")
      raise ArgumentError, "Missing required payload keys: #{missing_keys.join(', ')}"
    end
  end

  def find_company
    uuid = @payload.dig("company", "company_droplet_uuid")
    fluid_company_id = @payload.dig("company", "fluid_company_id")

    Company.find_by(company_droplet_uuid: uuid) || Company.find_by(fluid_company_id: fluid_company_id)
  end
end
