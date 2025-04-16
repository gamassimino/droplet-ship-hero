require "test_helper"

describe Company do
  fixtures(:companies)
  fixtures(:events)

  describe "validations" do
    it "is valid with valid attributes" do
      company = companies(:acme)
      _(company).must_be :valid?
    end

    it "is not valid without a name" do
      company = companies(:acme).dup
      company.name = nil
      _(company).wont_be :valid?
    end

    it "is not valid without a fluid_shop" do
      company = companies(:acme).dup
      company.fluid_shop = nil
      _(company).wont_be :valid?
    end

    it "is not valid without an authentication_token" do
      company = companies(:acme).dup
      company.authentication_token = nil
      _(company).wont_be :valid?
    end

    it "is not valid without a fluid_company_id" do
      company = companies(:acme).dup
      company.fluid_company_id = nil
      _(company).wont_be :valid?
    end

    it "is not valid without a company_droplet_uuid" do
      company = companies(:acme).dup
      company.company_droplet_uuid = nil
      _(company).wont_be :valid?
    end

    it "requires unique authentication_token" do
      existing_company = companies(:acme)
      company = companies(:globex).dup
      company.authentication_token = existing_company.authentication_token

      _(company).wont_be :valid?
      _(company.errors[:authentication_token]).must_include "has already been taken"
    end
  end

  describe "associations" do
    it "has many events" do
      company = companies(:acme)
      _(company.events).must_include events(:order_completed)
      _(company.events).must_include events(:product_updated)
      _(company.events.count).must_equal 2
    end

    it "destroys associated events when destroyed" do
      company = companies(:acme)
      event_count = company.events.count
      assert_difference "Event.count", -event_count do
        company.destroy
      end
    end
  end
end
