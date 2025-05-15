class DropletUninstalledJob < WebhookEventJob
  queue_as :default

  # Expects event_type, service_id, payload (handled by WebhookEventJob)
  def process_webhook
    validate_payload_keys("company")
    company = get_company

    if company.present?
      company.update(uninstalled_at: Time.current)
    else
      Rails.logger.warn("[DropletUninstalledJob] Company not found for payload: #{get_payload.inspect}")
    end
  end
end
