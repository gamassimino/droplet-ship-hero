class DropletReinstalledJob < WebhookEventJob
  # Expects event_type, service_id, payload
  def process_webhook
    validate_payload_keys("company")
    company = get_company

    if company.present?
      company.update(uninstalled_at: nil)
    else
      Rails.logger.warn("[DropletReinstalledJob] Company not found for payload: #{payload.inspect}")
    end
  end
end
