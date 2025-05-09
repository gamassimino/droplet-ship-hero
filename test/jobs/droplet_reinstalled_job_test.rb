require "test_helper"

describe DropletReinstalledJob do
  fixtures(:companies)

  describe "#perform" do
    it "marks company as installed" do
      # Set up an uninstalled company
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      # Create payload with company identifier
      payload = {
        "company" => {
          "company_droplet_uuid" => company.company_droplet_uuid,
          "fluid_company_id" => company.fluid_company_id,
        },
      }

      # Run the job and check that the company is marked as installed
      _(company.reload.uninstalled_at).wont_be_nil

      DropletReinstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).must_be_nil
    end

    it "finds company by uuid if provided" do
      # Set up an uninstalled company
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      # Create payload with only uuid
      payload = {
        "company" => {
          "company_droplet_uuid" => company.company_droplet_uuid,
        },
      }

      DropletReinstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).must_be_nil
    end

    it "finds company by fluid_company_id if provided" do
      # Set up an uninstalled company
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      # Create payload with only fluid_company_id
      payload = {
        "company" => {
          "fluid_company_id" => company.fluid_company_id,
        },
      }

      DropletReinstalledJob.perform_now(payload)

      _(company.reload.uninstalled_at).must_be_nil
    end

    it "handles missing company gracefully" do
      # Set up an uninstalled company for comparison
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      # Create payload with non-existent identifiers
      payload = {
        "company" => {
          "company_droplet_uuid" => "non-existent-uuid",
          "fluid_company_id" => 9999999,
        },
      }

      # Save the original uninstalled_at time for comparison
      original_uninstalled_at = company.reload.uninstalled_at

      # Job should run without raising errors
      _(-> { DropletReinstalledJob.perform_now(payload) }).must_be_silent

      # Original company should remain unchanged
      _(company.reload.uninstalled_at.to_i).must_equal original_uninstalled_at.to_i
    end

    it "handles empty payload gracefully" do
      # Set up an uninstalled company for comparison
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      # Empty payload
      payload = {}

      # Save the original uninstalled_at time for comparison
      original_uninstalled_at = company.reload.uninstalled_at

      # Job should run without raising errors
      _(-> { DropletReinstalledJob.perform_now(payload) }).must_be_silent

      # Original company should remain unchanged
      _(company.reload.uninstalled_at.to_i).must_equal original_uninstalled_at.to_i
    end
  end
end
