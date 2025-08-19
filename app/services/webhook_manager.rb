# frozen_string_literal: true

class WebhookManager
  def initialize(client)
    @client = client
  end

  def create
    installation_webhook = create_installation_webhook
    uninstallation_webhook = create_uninstallation_webhook

    update_webhook_setting(installation_webhook, uninstallation_webhook)

    {
      installation_webhook: installation_webhook,
      uninstallation_webhook: uninstallation_webhook,
    }
  end

  def update
    webhook_setting = Setting.fluid_webhook

    installation_webhook = update_installation_webhook(webhook_setting.values["webhook_installation_id"])
    uninstallation_webhook = update_uninstallation_webhook(webhook_setting.values["webhook_uninstallation_id"])

    {
      installation_webhook: installation_webhook,
      uninstallation_webhook: uninstallation_webhook,
    }
  end

private

  attr_reader :client

  def create_installation_webhook
    response = @client.webhooks.create(installation_webhook_attributes)
    response["webhook"]
  end

  def create_uninstallation_webhook
    response = @client.webhooks.create(uninstallation_webhook_attributes)
    response["webhook"]
  end

  def update_installation_webhook(webhook_id)
    return nil if webhook_id.blank?

    response = @client.webhooks.update(webhook_id, installation_webhook_attributes)
    response["webhook"]
  end

  def update_uninstallation_webhook(webhook_id)
    return nil if webhook_id.blank?

    response = @client.webhooks.update(webhook_id, uninstallation_webhook_attributes)
    response["webhook"]
  end

  def update_webhook_setting(installation_webhook, uninstallation_webhook)
    webhook_setting = Setting.fluid_webhook
    webhook_setting.values["webhook_installation_id"] = installation_webhook["id"].to_s
    webhook_setting.values["webhook_uninstallation_id"] = uninstallation_webhook["id"].to_s
    webhook_setting.save!
  end

  def installation_webhook_attributes
    webhook_setting = Setting.fluid_webhook
    {
      resource: "droplet",
      url: webhook_setting.url,
      active: true,
      auth_token: webhook_setting.auth_token,
      event: "installed",
      http_method: webhook_setting.http_method.downcase,
    }
  end

  def uninstallation_webhook_attributes
    webhook_setting = Setting.fluid_webhook
    {
      resource: "droplet",
      url: webhook_setting.url,
      active: true,
      auth_token: webhook_setting.auth_token,
      event: "uninstalled",
      http_method: webhook_setting.http_method.downcase,
    }
  end
end
