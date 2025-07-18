require "test_helper"

describe DropletInstalledJob do
  describe "#perform" do
    it "creates a company from payload when company doesn't exist" do
      company_data = {
        "fluid_shop" => "unique-test-shop-123",
        "name" => "Test Shop",
        "fluid_company_id" => 12345,
        "droplet_uuid" => "test-uuid-123",
        "authentication_token" => "unique-test-auth-token",
        "webhook_verification_token" => "test-verify-token",
        "droplet_installation_uuid" => "test-installation-uuid-123",
      }

      payload = { "company" => company_data }

      _(-> { DropletInstalledJob.perform_now(payload) }).must_change "Company.count", +1

      # Find the created company
      company = Company.last

      # Verify company attributes
      _(company.fluid_shop).must_equal "unique-test-shop-123"
      _(company.name).must_equal "Test Shop"
      _(company.fluid_company_id).must_equal 12345
      _(company.company_droplet_uuid).must_equal "test-uuid-123"
      _(company.authentication_token).must_equal "unique-test-auth-token"
      _(company.webhook_verification_token).must_equal "test-verify-token"
      _(company.droplet_installation_uuid).must_equal "test-installation-uuid-123"
      _(company).must_be :active?
    end

    it "updates existing company when company already exists" do
      existing_company = Company.create!(
        fluid_shop: "unique-update-shop-456",
        name: "Old Name",
        fluid_company_id: 12345,
        company_droplet_uuid: "old-uuid",
        authentication_token: "unique-old-token",
        webhook_verification_token: "old-verify-token",
        active: false
      )

      company_data = {
        "fluid_shop" => "unique-update-shop-456",
        "name" => "Updated Shop",
        "fluid_company_id" => 12345,
        "droplet_uuid" => "new-uuid-123",
        "authentication_token" => "unique-new-auth-token",
        "webhook_verification_token" => "new-verify-token",
        "droplet_installation_uuid" => "new-installation-uuid-456",
      }

      payload = { "company" => company_data }

      _(-> { DropletInstalledJob.perform_now(payload) }).wont_change "Company.count"

      existing_company.reload
      _(existing_company.name).must_equal "Updated Shop"
      _(existing_company.company_droplet_uuid).must_equal "new-uuid-123"
      _(existing_company.authentication_token).must_equal "unique-new-auth-token"
      _(existing_company.webhook_verification_token).must_equal "new-verify-token"
      _(existing_company.droplet_installation_uuid).must_equal "new-installation-uuid-456"
      _(existing_company).must_be :active?
    end

    it "handles missing company droplet data" do
      # Empty payload
      payload = {}

      # Job should run without creating a company or raising errors
      _(-> { DropletInstalledJob.perform_now(payload) }).wont_change "Company.count"
    end

    it "handles invalid company data" do
      # Create invalid data (missing required fields)
      payload = {
        "company" => {
          "name" => "Invalid Company",
          # Missing required fields
        },
      }

      # Job should run without creating a company or raising errors
      _(-> { DropletInstalledJob.perform_now(payload) }).wont_change "Company.count"
    end
  end
end
