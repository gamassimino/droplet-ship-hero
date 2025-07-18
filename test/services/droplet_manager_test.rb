require "test_helper"

class DropletManagerTest < ActiveSupport::TestCase
  def setup
    @mock_client = Minitest::Mock.new
    @mock_droplets = Minitest::Mock.new
    @droplet_manager = DropletManager.new(@mock_client)
  end

  test "creates a droplet successfully" do
    droplet_data = {
      "uuid" => "new-uuid-123",
      "name" => "Test Droplet",
      "active" => true,
      "embed_url" => "https://example.com/embed",
    }

    response_data = { "droplet" => droplet_data }

    @mock_droplets.expect :create, response_data
    @mock_client.expect :droplets, @mock_droplets

    result = @droplet_manager.create

    assert_equal droplet_data, result
    @mock_client.verify
    @mock_droplets.verify
  end

  test "updates droplet setting when creating droplet" do
    droplet_data = {
      "uuid" => "new-uuid-456",
      "name" => "Updated Droplet",
      "active" => false,
      "embed_url" => "https://example.com/updated",
    }

    response_data = { "droplet" => droplet_data }

    @mock_droplets.expect :create, response_data
    @mock_client.expect :droplets, @mock_droplets

    @droplet_manager.create

    setting = Setting.droplet
    assert_equal "new-uuid-456", setting.values["uuid"]
    assert_equal "Updated Droplet", setting.values["name"]
    assert_equal false, setting.values["active"]
    assert_equal "https://example.com/updated", setting.values["embed_url"]

    @mock_client.verify
    @mock_droplets.verify
  end

  test "updates droplet successfully" do
    @mock_droplets.expect :update, { "status" => "updated" }
    @mock_client.expect :droplets, @mock_droplets

    result = @droplet_manager.update

    assert_equal({ "status" => "updated" }, result)
    @mock_client.verify
    @mock_droplets.verify
  end

  test "handles client errors gracefully" do
    def @mock_droplets.create; raise FluidClient::APIError.new("API Error"); end
    @mock_client.expect :droplets, @mock_droplets

    error = assert_raises(FluidClient::APIError) do
      @droplet_manager.create
    end
    assert_equal "API Error", error.message
    @mock_client.verify
  end

  test "initializes with client" do
    client = Object.new
    manager = DropletManager.new(client)
    assert_same client, manager.send(:client)
  end

  test "only updates specific droplet fields in setting" do
    droplet_data = {
      "uuid" => "test-uuid",
      "name" => "Test Name",
      "active" => true,
      "embed_url" => "https://test.com",
      "extra_field" => "should_not_be_saved",
    }

    response_data = { "droplet" => droplet_data }

    @mock_droplets.expect :create, response_data
    @mock_client.expect :droplets, @mock_droplets

    @droplet_manager.create

    setting = Setting.droplet
    assert_equal "test-uuid", setting.values["uuid"]
    assert_equal "Test Name", setting.values["name"]
    assert_equal true, setting.values["active"]
    assert_equal "https://test.com", setting.values["embed_url"]

    assert_nil setting.values["extra_field"]

    @mock_client.verify
    @mock_droplets.verify
  end

  test "overwrites existing setting fields with droplet data" do
    existing_setting = Setting.droplet
    existing_setting.values["custom_field"] = "existing_value"
    existing_setting.save!

    droplet_data = {
      "uuid" => "new-uuid",
      "name" => "New Name",
    }

    response_data = { "droplet" => droplet_data }

    @mock_droplets.expect :create, response_data
    @mock_client.expect :droplets, @mock_droplets

    @droplet_manager.create

    setting = Setting.droplet
    assert_equal "new-uuid", setting.values["uuid"]
    assert_equal "New Name", setting.values["name"]
    assert_nil setting.values["custom_field"]

    @mock_client.verify
    @mock_droplets.verify
  end
end
