require "test_helper"

# Test subclass implementation
class TestWebhookJob < WebhookEventJob
  attr_reader :process_webhook_called

  def process_webhook
    @process_webhook_called = true
  end
end

# Failing test subclass to test error handling
class FailingWebhookJob < WebhookEventJob
  def process_webhook
    raise "Test error"
  end
end

# Abstract job test subclass (doesn't implement process_webhook)
class AbstractWebhookJob < WebhookEventJob
end

describe WebhookEventJob do
  fixtures(:companies)

  before do
    # Register the test job
    EventHandler.register_handler("test.webhook", TestWebhookJob)
  end

  after do
    # Clear test handlers
    EventHandler::EVENT_HANDLERS.delete("test.webhook")
  end

  describe "self.event_type" do
    it "returns the registered event type for the job" do
      _(TestWebhookJob.event_type).must_equal "test.webhook"
    end

    it "returns nil for unregistered job" do
      _(FailingWebhookJob.event_type).must_be_nil
    end
  end

  describe "#perform" do
    it "sets instance variables and calls process_webhook" do
      # Create test payload with company info
      company = companies(:acme)
      payload = {
        "company" => {
          "company_droplet_uuid" => company.company_droplet_uuid,
          "fluid_company_id" => company.fluid_company_id,
        },
      }

      # Run the job
      job = TestWebhookJob.new
      job.perform(payload)

      # Verify instance variables
      _(job.instance_variable_get(:@payload)).must_equal payload
      _(job.instance_variable_get(:@event_type)).must_equal "test.webhook"
      _(job.instance_variable_get(:@company)).must_equal company
      _(job.process_webhook_called).must_equal true
    end

    it "raises NotImplementedError for abstract subclasses" do
      _(-> { AbstractWebhookJob.perform_now({}) }).must_raise NotImplementedError
    end
  end

  describe "accessor methods" do
    it "provides access to payload data" do
      job = TestWebhookJob.new
      test_payload = { "test" => "data" }
      job.instance_variable_set(:@payload, test_payload)

      _(job.send(:get_payload)).must_equal test_payload
    end

    it "provides access to company data" do
      job = TestWebhookJob.new
      company = companies(:acme)
      job.instance_variable_set(:@company, company)

      _(job.send(:get_company)).must_equal company
    end

    it "provides access to event_type" do
      job = TestWebhookJob.new
      job.instance_variable_set(:@event_type, "test.event")

      _(job.send(:get_event_type)).must_equal "test.event"
    end
  end

  describe "#validate_payload_keys" do
    it "raises ArgumentError when required keys are missing" do
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, { "foo" => "bar" })

      error = _(-> { job.send(:validate_payload_keys, "company", "other_key") }).must_raise ArgumentError
      _(error.message).must_match /Missing required payload keys: company, other_key/
    end

    it "does nothing when all required keys are present" do
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, { "company" => {}, "other_key" => "value" })

      # Should not raise error
      _(job.send(:validate_payload_keys, "company", "other_key")).must_be_nil
    end
  end

  describe "#find_company" do
    it "finds company by uuid" do
      company = companies(:acme)
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, {
        "company" => { "company_droplet_uuid" => company.company_droplet_uuid },
      })

      found_company = job.send(:find_company)
      _(found_company).must_equal company
    end

    it "finds company by fluid_company_id" do
      company = companies(:acme)
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, {
        "company" => { "fluid_company_id" => company.fluid_company_id },
      })

      found_company = job.send(:find_company)
      _(found_company).must_equal company
    end

    it "returns nil when company not found" do
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, {
        "company" => {
          "company_droplet_uuid" => "non-existent-uuid",
          "fluid_company_id" => 999999,
        },
      })

      found_company = job.send(:find_company)
      _(found_company).must_be_nil
    end

    it "returns nil for empty payload" do
      job = TestWebhookJob.new
      job.instance_variable_set(:@payload, {})

      found_company = job.send(:find_company)
      _(found_company).must_be_nil
    end
  end
end
