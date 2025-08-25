require "test_helper"

module DropletUseCaseTestHelpers
  def build_create_use_case(client: nil)
    DropletUseCase::Create.new(client: client)
  end

  def build_update_use_case(client: nil)
    DropletUseCase::Update.new(client: client)
  end
end

class DropletUseCaseTest < ActiveSupport::TestCase
  include DropletUseCaseTestHelpers

  def setup
    @mock_droplet_manager = Minitest::Mock.new
    @mock_webhook_manager = Minitest::Mock.new
    @mock_client = Minitest::Mock.new
  end

  def inject_managers(use_case)
    use_case.instance_variable_set(:@droplet_manager, @mock_droplet_manager)
    use_case.instance_variable_set(:@webhook_manager, @mock_webhook_manager)
    def use_case.droplet_manager; @droplet_manager; end
    def use_case.webhook_manager; @webhook_manager; end
  end

  test "DropletUseCase::Create returns success with droplet and webhook data" do
    droplet_data = { "uuid" => "abc" }
    webhook_data = {
      installation_webhook: { "id" => "web-1" },
      uninstallation_webhook: { "id" => "web-2" },
    }

    @mock_droplet_manager.expect :create, droplet_data
    @mock_webhook_manager.expect :create, webhook_data

    use_case = DropletUseCase::Create.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal true, result[:success]
    assert_equal droplet_data, result[:droplet]
    assert_equal webhook_data[:installation_webhook], result[:installation_webhook]
    assert_equal webhook_data[:uninstallation_webhook], result[:uninstallation_webhook]
    @mock_droplet_manager.verify
    @mock_webhook_manager.verify
  end

  test "DropletUseCase::Create returns failure on FluidClient::Error from droplet creation" do
    @mock_droplet_manager.expect :create, nil do
      raise FluidClient::Error.new("fail")
    end
    use_case = DropletUseCase::Create.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal false, result[:success]
    assert_equal "fail", result[:error]
  end

  test "DropletUseCase::Create returns failure on FluidClient::Error from webhook creation" do
    droplet_data = { "uuid" => "abc" }
    @mock_droplet_manager.expect :create, droplet_data
    @mock_webhook_manager.expect :create, nil do
      raise FluidClient::Error.new("webhook fail")
    end
    use_case = DropletUseCase::Create.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal false, result[:success]
    assert_equal "webhook fail", result[:error]
  end

  test "DropletUseCase::Update returns success with webhook data" do
    webhook_data = {
      installation_webhook: { "id" => "web-2" },
      uninstallation_webhook: { "id" => "web-3" },
    }
    @mock_droplet_manager.expect :update, nil
    @mock_webhook_manager.expect :update, webhook_data

    use_case = DropletUseCase::Update.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal true, result[:success]
    assert_equal webhook_data, result[:webhook]
    @mock_droplet_manager.verify
    @mock_webhook_manager.verify
  end

  test "DropletUseCase::Update returns failure on FluidClient::Error from droplet update" do
    @mock_droplet_manager.expect :update, nil do
      raise FluidClient::Error.new("fail update")
    end
    use_case = DropletUseCase::Update.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal false, result[:success]
    assert_equal "fail update", result[:error]
  end

  test "DropletUseCase::Update returns failure on FluidClient::Error from webhook update" do
    @mock_droplet_manager.expect :update, nil
    @mock_webhook_manager.expect :update, nil do
      raise FluidClient::Error.new("webhook update fail")
    end
    use_case = DropletUseCase::Update.allocate
    inject_managers(use_case)

    result = use_case.call
    assert_equal false, result[:success]
    assert_equal "webhook update fail", result[:error]
  end

  test "DropletUseCase::Base uses fluid api key for authentication" do
    use_case = DropletUseCase::Create.new
    client = use_case.send(:client)
    assert_equal Setting.fluid_api.api_key, client.instance_variable_get(:@auth_token)
  end
end
