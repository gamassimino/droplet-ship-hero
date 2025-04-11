require "test_helper"

describe Event do
  describe "validations" do
    it "is valid with all attributes" do
      event = events(:order_completed)
      _(event.valid?).must_equal true
    end

    it "is invalid without identifier" do
      event = events(:order_completed)
      event.identifier = nil
      _(event.valid?).must_equal false
      _(event.errors[:identifier]).wont_be_empty
    end

    it "is invalid without name" do
      event = events(:order_completed)
      event.name = nil
      _(event.valid?).must_equal false
      _(event.errors[:name]).wont_be_empty
    end

    it "is invalid without payload" do
      event = events(:order_completed)
      event.payload = nil
      _(event.valid?).must_equal false
      _(event.errors[:payload]).wont_be_empty
    end

    it "is invalid without timestamp" do
      event = events(:order_completed)
      event.timestamp = nil
      _(event.valid?).must_equal false
      _(event.errors[:timestamp]).wont_be_empty
    end

    it "is invalid without status" do
      event = events(:order_completed)
      event.status = nil
      _(event.valid?).must_equal false
      _(event.errors[:status]).wont_be_empty
    end
  end

  describe "status enum" do
    it "works correctly" do
      pending_event = events(:order_completed)
      processed_event = events(:product_updated)
      failed_event = events(:cart_abandoned)

      _(pending_event.pending?).must_equal true
      _(processed_event.processed?).must_equal true
      _(failed_event.failed?).must_equal true

      _(Event.statuses["pending"]).must_equal 0
      _(Event.statuses["processed"]).must_equal 1
      _(Event.statuses["failed"]).must_equal 2
    end
  end

  describe "payload" do
    it "can store and retrieve JSON data" do
      event = events(:order_completed)
      _(event.payload["order_id"]).must_equal "123"
      _(event.payload["status"]).must_equal "completed"
      _(event.payload["total"]).must_equal 99.99
    end
  end

  describe "webhook names" do
    it "accepts all webhook event names from Fluid API" do
      webhook_names = %w[
        cart_abandoned cart_updated contact_created
        contact_updated event_created event_deleted
        event_updated order_cancelled order_completed
        order_updated order_shipped order_refunded
        popup_submitted product_created product_updated
        product_destroyed subscription_started subscription_paused
        subscription_cancelled user_created user_updated
        user_deactivated
      ]

      webhook_names.each do |name|
        event = Event.new(
          identifier: "test_#{name}",
          name: name,
          payload: { test: true },
          timestamp: Time.current,
          status: :pending
        )
        _(event.valid?).must_equal true, "Event should be valid with name: #{name}"
      end
    end
  end
end
