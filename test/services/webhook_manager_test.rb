require "test_helper"

class WebhookManagerTest < ActiveSupport::TestCase
  def setup
    @mock_client = Minitest::Mock.new
    @mock_webhooks = Minitest::Mock.new
    @webhook_manager = WebhookManager.new(@mock_client)
  end

  test "creates a webhook successfully" do
    installation_webhook_data = {
      "id" => "webhook-install-123",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    uninstallation_webhook_data = {
      "id" => "webhook-uninstall-456",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "uninstalled",
    }

    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    @mock_webhooks.expect :create, installation_response, [ Hash ]
    @mock_webhooks.expect :create, uninstallation_response, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    result = @webhook_manager.create

    expected_result = {
      installation_webhook: installation_webhook_data,
      uninstallation_webhook: uninstallation_webhook_data,
    }
    assert_equal expected_result, result
    @mock_client.verify
    @mock_webhooks.verify
  end

  test "updates webhook setting when creating webhook" do
    installation_webhook_data = {
      "id" => "new-webhook-install-456",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    uninstallation_webhook_data = {
      "id" => "new-webhook-uninstall-789",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "uninstalled",
    }

    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    @mock_webhooks.expect :create, installation_response, [ Hash ]
    @mock_webhooks.expect :create, uninstallation_response, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    setting = Setting.fluid_webhook
    assert_equal "new-webhook-install-456", setting.values["webhook_installation_id"]
    assert_equal "new-webhook-uninstall-789", setting.values["webhook_uninstallation_id"]

    @mock_client.verify
    @mock_webhooks.verify
  end

  test "updates webhook successfully" do
    installation_webhook_data = {
      "id" => "webhook-install-789",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    uninstallation_webhook_data = {
      "id" => "webhook-uninstall-999",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "uninstalled",
    }

    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    @mock_webhooks.expect :update, installation_response, [ String, Hash ]
    @mock_webhooks.expect :update, uninstallation_response, [ String, Hash ]
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    result = @webhook_manager.update

    expected_result = {
      installation_webhook: installation_webhook_data,
      uninstallation_webhook: uninstallation_webhook_data,
    }
    assert_equal expected_result, result
    @mock_client.verify
    @mock_webhooks.verify
  end

  test "does not update setting when updating webhook" do
    installation_webhook_data = {
      "id" => "webhook-install-999",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    uninstallation_webhook_data = {
      "id" => "webhook-uninstall-888",
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "uninstalled",
    }

    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    @mock_webhooks.expect :update, installation_response, [ String, Hash ]
    @mock_webhooks.expect :update, uninstallation_response, [ String, Hash ]
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    original_installation_id = Setting.fluid_webhook.values["webhook_installation_id"]
    original_uninstallation_id = Setting.fluid_webhook.values["webhook_uninstallation_id"]

    @webhook_manager.update

    setting = Setting.fluid_webhook
    assert_equal original_installation_id, setting.values["webhook_installation_id"]
    assert_equal original_uninstallation_id, setting.values["webhook_uninstallation_id"]

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
    installation_webhook_data = {
      "id" => 12345, # Integer ID
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "installed",
    }

    uninstallation_webhook_data = {
      "id" => 67890, # Integer ID
      "resource" => "droplet",
      "url" => "http://localhost:3200/webhook",
      "active" => true,
      "event" => "uninstalled",
    }

    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    @mock_webhooks.expect :create, installation_response, [ Hash ]
    @mock_webhooks.expect :create, uninstallation_response, [ Hash ]
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    setting = Setting.fluid_webhook
    assert_equal "12345", setting.values["webhook_installation_id"]
    assert_equal "67890", setting.values["webhook_uninstallation_id"]
    assert_instance_of String, setting.values["webhook_installation_id"]
    assert_instance_of String, setting.values["webhook_uninstallation_id"]

    @mock_client.verify
    @mock_webhooks.verify
  end

  test "uses correct webhook attributes from settings" do
    webhook_setting = Setting.fluid_webhook
    webhook_setting.values["url"] = "https://custom-webhook.com/endpoint"
    webhook_setting.values["auth_token"] = "custom_auth_token"
    webhook_setting.values["http_method"] = "PUT"
    webhook_setting.save!

    installation_webhook_data = { "id" => "test-install-id" }
    uninstallation_webhook_data = { "id" => "test-uninstall-id" }
    installation_response = { "webhook" => installation_webhook_data }
    uninstallation_response = { "webhook" => uninstallation_webhook_data }

    captured_installation_attributes = nil
    captured_uninstallation_attributes = nil

    @mock_webhooks.expect :create, installation_response do |attributes|
      captured_installation_attributes = attributes
    end
    @mock_webhooks.expect :create, uninstallation_response do |attributes|
      captured_uninstallation_attributes = attributes
    end
    @mock_client.expect :webhooks, @mock_webhooks
    @mock_client.expect :webhooks, @mock_webhooks

    @webhook_manager.create

    # Check installation webhook attributes
    assert_equal "droplet", captured_installation_attributes[:resource]
    assert_equal "https://custom-webhook.com/endpoint", captured_installation_attributes[:url]
    assert_equal true, captured_installation_attributes[:active]
    assert_equal "custom_auth_token", captured_installation_attributes[:auth_token]
    assert_equal "installed", captured_installation_attributes[:event]
    assert_equal "put", captured_installation_attributes[:http_method]

    # Check uninstallation webhook attributes
    assert_equal "droplet", captured_uninstallation_attributes[:resource]
    assert_equal "https://custom-webhook.com/endpoint", captured_uninstallation_attributes[:url]
    assert_equal true, captured_uninstallation_attributes[:active]
    assert_equal "custom_auth_token", captured_uninstallation_attributes[:auth_token]
    assert_equal "uninstalled", captured_uninstallation_attributes[:event]
    assert_equal "put", captured_uninstallation_attributes[:http_method]

    @mock_client.verify
    @mock_webhooks.verify
  end
end
