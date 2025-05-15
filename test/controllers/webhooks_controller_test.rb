require "test_helper"


describe WebhooksController do
  fixtures(:companies)

  describe "company_droplet events" do
    it "handles company_droplet created event" do
      company_data = {
        fluid_shop: "test-shop",
        name: "Test Company",
        fluid_company_id: 123456,
        company_droplet_uuid: "abc-123-xyz",
        authentication_token: "secret-token-123",
        webhook_verification_token: "verify-token-456",
      }

      post webhook_url, params: {
        resource: "company_droplet",
        event: "created",
        company: company_data,
      }, as: :json

      _(response.status).must_equal 202

      perform_enqueued_jobs

      company = Company.order(:created_at).last
      _(company.fluid_shop).must_equal "test-shop"
      _(company.name).must_equal "Test Company"
      _(company.fluid_company_id).must_equal 123456
      _(company.company_droplet_uuid).must_equal "abc-123-xyz"
      _(company).must_be :active?
    end

    it "handles company_droplet uninstalled event with valid authentication token in header" do
      company = companies(:acme)
      post webhook_url, params: {
        resource: "company_droplet",
        event: "uninstalled",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
        },
      }, headers: { "AUTH_TOKEN" => company.webhook_verification_token }, as: :json

      _(response.status).must_equal 202

      perform_enqueued_jobs

      company.reload
      _(company.uninstalled_at).wont_be_nil
    end

    it "handles company_droplet installed event with valid token" do
      # First mark the company as uninstalled
      company = companies(:acme)
      company.update(uninstalled_at: Time.current)

      post webhook_url, params: {
        resource: "company_droplet",
        event: "installed",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
          webhook_verification_token: company.webhook_verification_token,
        },
      }, headers: { "AUTH_TOKEN" => company.webhook_verification_token }, as: :json

      _(response.status).must_equal 202

      perform_enqueued_jobs

      company.reload
      _(company.uninstalled_at).must_be_nil
    end

    it "rejects event when webhook verification token is invalid" do
      company = companies(:acme)
      post webhook_url, params: {
        resource: "company_droplet",
        event: "uninstalled",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
          webhook_verification_token: "invalid-token",
        },
      }, headers: { "AUTH_TOKEN" => "invalid-token" }, as: :json

      _(response.status).must_equal 401
      _(JSON.parse(response.body)["error"]).must_equal "Unauthorized"
    end

    it "rejects event when authentication token in header is invalid" do
      company = companies(:acme)
      post webhook_url, params: {
        resource: "company_droplet",
        event: "uninstalled",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
        },
      }, headers: { "AUTH_TOKEN" => "invalid-token" }, as: :json

      _(response.status).must_equal 401
      _(JSON.parse(response.body)["error"]).must_equal "Unauthorized"
    end

    it "returns 404 when company is not found" do
      post webhook_url, params: {
        resource: "company_droplet",
        event: "uninstalled",
        company: {
          company_droplet_uuid: "non-existent-uuid",
          fluid_company_id: 999999,
          webhook_verification_token: "any-token",
        },
      }, headers: { "AUTH_TOKEN" => "any-token" }, as: :json

      _(response.status).must_equal 404
      _(JSON.parse(response.body)["error"]).must_equal "Company not found"
    end

    it "relies on company payload for authentication if auth token is not provided" do
      company = companies(:acme)
      post webhook_url, params: {
        resource: "company_droplet",
        event: "uninstalled",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
          webhook_verification_token: company.webhook_verification_token,
        },
      }, as: :json

      _(response.status).must_equal 202

      perform_enqueued_jobs

      company.reload
      _(company.uninstalled_at).wont_be_nil
    end

    it "bypasses verification for company_droplet created event" do
      company_data = {
        fluid_shop: "new-shop",
        name: "New Company",
        fluid_company_id: 999999,
        company_droplet_uuid: "new-uuid-123",
        authentication_token: "new-secret-token",
        webhook_verification_token: "new-verify-token",
      }

      # No webhook_verification_token provided, but should still succeed

      post webhook_url, params: {
        resource: "company_droplet",
        event: "created",
        company: company_data,
      }, as: :json

      _(response.status).must_equal 202
    end
  end

  describe "unknown events" do
    it "handles unknown event types with no content" do
      company = companies(:acme)

      post webhook_url, params: {
        resource: "unknown_resource",
        event: "unknown_event",
        company: {
          company_droplet_uuid: company.company_droplet_uuid,
          fluid_company_id: company.fluid_company_id,
          webhook_verification_token: company.webhook_verification_token,
        },
      }, as: :json

      _(response.status).must_equal 204
    end
  end
end
