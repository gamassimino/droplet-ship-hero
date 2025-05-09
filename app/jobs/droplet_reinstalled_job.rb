class DropletReinstalledJob < ApplicationJob
  queue_as :default

  def perform(payload)
    company = find_company(payload)

    if company.present?
      company.update(uninstalled_at: nil)
    else
      Rails.logger.warn("[DropletReinstalledJob] Company not found for payload: #{payload.inspect}")
    end
  rescue StandardError => e
    Rails.logger.error("[DropletReinstalledJob] Error: #{e.class} - #{e.message}")
    raise
  end

private

  def find_company(payload)
    uuid = payload.dig("company", "company_droplet_uuid")
    fluid_company_id = payload.dig("company", "fluid_company_id")

    Company.find_by(company_droplet_uuid: uuid) || Company.find_by(fluid_company_id: fluid_company_id)
  end
end
