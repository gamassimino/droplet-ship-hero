require "test_helper"

class WebhookManagerTest < ActiveSupport::TestCase
  def setup
    @mock_client = Minitest::Mock.new
    @mock_webhooks = Minitest::Mock.new
    @webhook_manager = WebhookManager.new(@mock_client)
  end

  test "creates a webhook successfully" do
    webhook_data = {
      "id" => "webhook-123",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    response_data = { "webhook" => webhook_data }

    @mock_webhooks.expect :create, response_data, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks

    result = @webhook_manager.create

    assert_equal webhook_data, result
    @mock_client.verify
    @mock_webhooks.verify
  end

  test "updates webhook setting when creating webhook" do
    webhook_data = {
      "id" => "new-webhook-456",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    response_data = { "webhook" => webhook_data }

    @mock_webhooks.expect :create, response_data, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    setting = Setting.fluid_webhook
    assert_equal "new-webhook-456", setting.values["webhook_id"]

    @mock_client.verify
    @mock_webhooks.verify
  end

  test "updates webhook successfully" do
    webhook_data = {
      "id" => "webhook-789",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    response_data = { "webhook" => webhook_data }

    @mock_webhooks.expect :update, response_data, [ String, Hash ]
    @mock_client.expect :webhooks, @mock_webhooks

    result = @webhook_manager.update

    assert_equal webhook_data, result
    @mock_client.verify
    @mock_webhooks.verify
  end

  test "does not update setting when updating webhook" do
    webhook_data = {
      "id" => "webhook-999",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    response_data = { "webhook" => webhook_data }

    @mock_webhooks.expect :update, response_data, [ String, Hash ]
    @mock_client.expect :webhooks, @mock_webhooks

    original_webhook_id = Setting.fluid_webhook.values["webhook_id"]

    @webhook_manager.update

    setting = Setting.fluid_webhook
    assert_equal original_webhook_id, setting.values["webhook_id"]

    @mock_client.verify
    @mock_webhooks.verify
  end

  test "handles client errors gracefully" do
    @mock_webhooks.expect :create, nil do |args|
      raise FluidClient::APIError.new("API Error")
    end
    @mock_client.expect :webhooks, @mock_webhooks

    error = assert_raises(FluidClient::APIError) do
      @webhook_manager.create
    end
    assert_equal "API Error", error.message
    @mock_client.verify
  end

  test "initializes with client" do
    client = Object.new
    manager = WebhookManager.new(client)
    assert_same client, manager.send(:client)
  end

  test "converts webhook id to string when updating setting" do
    webhook_data = {
      "id" => 12345, # Integer ID
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    response_data = { "webhook" => webhook_data }

    @mock_webhooks.expect :create, response_data, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    setting = Setting.fluid_webhook
    assert_equal "12345", setting.values["webhook_id"]
    assert_instance_of String, setting.values["webhook_id"]

    @mock_client.verify
    @mock_webhooks.verify
  end

  test "uses correct webhook attributes from settings" do
    webhook_setting = Setting.fluid_webhook
    webhook_setting.values["url"] = "https://custom-webhook.com/endpoint"
    webhook_setting.values["auth_token"] = "custom_auth_token"
    webhook_setting.values["http_method"] = "PUT"
    webhook_setting.save!

    webhook_data = { "id" => "test-id" }
    response_data = { "webhook" => webhook_data }

    captured_attributes = nil
    @mock_webhooks.expect :create, response_data do |attributes|
      captured_attributes = attributes
    end
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    assert_equal "droplet", captured_attributes[:resource]
    assert_equal "https://custom-webhook.com/endpoint", captured_attributes[:url]
    assert_equal true, captured_attributes[:active]
    assert_equal "custom_auth_token", captured_attributes[:auth_token]
    assert_equal "installed", captured_attributes[:event]
    assert_equal "put", captured_attributes[:http_method]

    @mock_client.verify
    @mock_webhooks.verify
  end
end
