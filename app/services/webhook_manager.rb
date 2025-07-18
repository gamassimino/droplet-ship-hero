# frozen_string_literal: true

class WebhookManager
  def initialize(client)
    @client = client
  end

  def create
    response = @client.webhooks.create(webhook_attributes)
    update_webhook_setting(response["webhook"])
    response["webhook"]
  end

  def update
    webhook_id = Setting.fluid_webhook.values["webhook_id"]
    response = @client.webhooks.update(webhook_id, webhook_attributes)
    response["webhook"]
  end

private

  attr_reader :client

  def update_webhook_setting(webhook_data)
    webhook_setting = Setting.fluid_webhook
    webhook_setting.values["webhook_id"] = webhook_data["id"].to_s
    webhook_setting.save!
  end

  def webhook_attributes
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
end
