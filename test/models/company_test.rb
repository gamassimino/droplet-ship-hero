require "test_helper"

describe Company do
  fixtures(:companies)

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

    it "requires unique authentication_token" do
      existing_company = companies(:acme)
      company = companies(:globex).dup
      company.authentication_token = existing_company.authentication_token

      _(company).wont_be :valid?
      _(company.errors[:authentication_token]).must_include "has already been taken"
    end
  end
end
