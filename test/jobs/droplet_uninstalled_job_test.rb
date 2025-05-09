require "test_helper"

describe DropletUninstalledJob do
  fixtures(:companies)

  describe "#perform" do
    it "marks company as uninstalled" do
      # Set up an installed company
      company = companies(:acme)
      company.update(uninstalled_at: nil)

      # Create payload with company identifier
      payload = {
        "company" => {
          "company_droplet_uuid" => company.company_droplet_uuid,
          "fluid_company_id" => company.fluid_company_id,
        },
      }

      # Run the job and check that the company is marked as uninstalled
      _(company.reload.uninstalled_at).must_be_nil

      DropletUninstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).wont_be_nil
      _(company.uninstalled_at.to_i).must_be_close_to Time.current.to_i, 2
    end

    it "finds company by uuid if provided" do
      # Set up an installed company
      company = companies(:acme)
      company.update(uninstalled_at: nil)

      # Create payload with only uuid
      payload = {
        "company" => {
          "company_droplet_uuid" => company.company_droplet_uuid,
        },
      }

      DropletUninstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).wont_be_nil
    end

    it "finds company by fluid_company_id if provided" do
      # Set up an installed company
      company = companies(:acme)
      company.update(uninstalled_at: nil)

      # Create payload with only fluid_company_id
      payload = {
        "company" => {
          "fluid_company_id" => company.fluid_company_id,
        },
      }

      DropletUninstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).wont_be_nil
    end

    it "handles missing company gracefully" do
      # Set up an installed company for comparison
      company = companies(:acme)
      company.update(uninstalled_at: nil)

      # Create payload with non-existent identifiers
      payload = {
        "company" => {
          "company_droplet_uuid" => "non-existent-uuid",
          "fluid_company_id" => 9999999,
        },
      }

      # Job should run without raising errors
      _(-> { DropletUninstalledJob.perform_now(payload) }).must_be_silent

      # Original company should remain unchanged
      _(company.reload.uninstalled_at).must_be_nil
    end

    it "handles empty payload gracefully" do
      # Set up an installed company for comparison
      company = companies(:acme)
      company.update(uninstalled_at: nil)

      # Empty payload
      payload = {}

      # Job should run without raising errors
      _(-> { DropletUninstalledJob.perform_now(payload) }).must_be_silent

      # Original company should remain unchanged
      _(company.reload.uninstalled_at).must_be_nil
    end
  end
end
