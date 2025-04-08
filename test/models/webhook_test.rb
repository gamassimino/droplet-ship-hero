require "test_helper"

describe Webhook do
  fixtures :webhooks

  describe "validations" do
    it "is valid with valid attributes" do
      webhook = webhooks(:order_completed)
      _(webhook.valid?).must_equal true
    end

    it "is invalid with an invalid resource" do
      webhook = webhooks(:cart_updated)
      webhook.resource = "invalid"
      _(webhook.valid?).must_equal false
    end

    it "is invalid with an invalid event" do
      webhook = webhooks(:cart_abandoned)
      webhook.event = "deleted"
      _(webhook.valid?).must_equal false
    end
  end
end
