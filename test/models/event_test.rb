require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "valid event" do
    event = events(:order_completed)
    assert event.valid?
  end

  test "invalid without identifier" do
    event = events(:order_completed)
    event.identifier = nil
    refute event.valid?
    assert_not_nil event.errors[:identifier]
  end

  test "invalid without name" do
    event = events(:order_completed)
    event.name = nil
    refute event.valid?
    assert_not_nil event.errors[:name]
  end

  test "invalid without payload" do
    event = events(:order_completed)
    event.payload = nil
    refute event.valid?
    assert_not_nil event.errors[:payload]
  end

  test "invalid without timestamp" do
    event = events(:order_completed)
    event.timestamp = nil
    refute event.valid?
    assert_not_nil event.errors[:timestamp]
  end

  test "invalid without status" do
    event = events(:order_completed)
    event.status = nil
    refute event.valid?
    assert_not_nil event.errors[:status]
  end

  test "status enum works correctly" do
    pending_event = events(:order_completed)
    processed_event = events(:product_updated)
    failed_event = events(:cart_abandoned)

    assert pending_event.pending?
    assert processed_event.processed?
    assert failed_event.failed?

    assert_equal 0, Event.statuses["pending"]
    assert_equal 1, Event.statuses["processed"]
    assert_equal 2, Event.statuses["failed"]
  end

  test "can store and retrieve JSON payload" do
    event = events(:order_completed)
    assert_equal "123", event.payload["order_id"]
    assert_equal "completed", event.payload["status"]
    assert_equal 99.99, event.payload["total"]
  end

  test "can create event with webhook name from Fluid API" do
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
      assert event.valid?, "Event should be valid with name: #{name}"
    end
  end
end
