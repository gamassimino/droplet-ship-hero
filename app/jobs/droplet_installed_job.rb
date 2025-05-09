class DropletInstalledJob < ApplicationJob
  queue_as :default

  # payload - Hash received from the webhook controller.
  # Expected structure (example):
  # {
  #   "company" => {
  #     "fluid_shop" => "example.myshopify.com",
  #     "name" => "Example Shop",
  #     "fluid_company_id" => 123,
  #     "company_droplet_uuid" => "uuid",
  #     "authentication_token" => "token",
  #     "webhook_verification_token" => "verify",
  #   }
  # }
  def perform(payload)
    company_attributes = payload.fetch("company", {})

    company = Company.new(company_attributes.slice(
      "fluid_shop",
      "name",
      "fluid_company_id",
      "company_droplet_uuid",
      "authentication_token",
      "webhook_verification_token",
    ))

    company.active = true

    unless company.save
      Rails.logger.error(
        "[DropletInstalledJob] Failed to create company: #{company.errors.full_messages.join(', ')}"
      )
    end
  rescue StandardError => e
    Rails.logger.error("[DropletInstalledJob] Error: #{e.class} - #{e.message}")
    raise
  end
end
