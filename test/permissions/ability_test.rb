require "test_helper"

describe Ability do
  describe "when the user is nil" do
    it "cannot manage any resources" do
      ability = Ability.new(user: nil)

      _(ability.permissions[:can].empty?).must_equal true
    end
  end

  describe "when the user has no permissions" do
    it "cannot manage any resources" do
      user = User.new(
        email: "user@example.com",
        password: "test-password",
        password_confirmation: "test-password",
        permission_sets: []
      )
      ability = Ability.new(user: user)

      _(ability.permissions[:can].empty?).must_equal true
    end
  end

  describe "when the user has admin permissions" do
    it "can manage all resources" do
      user = User.new(
        email: "admin@example.com",
        password: "test-password",
        password_confirmation: "test-password",
        permission_sets: [ "AdminPermissions" ]
      )
      ability = Ability.new(user: user)

      _(ability.can?(:manage, :all)).must_equal true
    end
  end
end
