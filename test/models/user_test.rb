require "test_helper"

describe User do
  fixtures(:users)

  describe "#has_permission_set?" do
    it "returns true if the user has the permission set" do
      user = users(:admin)
      _(user.has_permission_set?("AdminPermissions")).must_equal true
    end

    it "returns false if the user does not have the permission set" do
      user = users(:none)
      _(user.has_permission_set?("AdminPermissions")).must_equal false
    end
  end

  describe "#add_permission_set" do
    it "adds the permission set to the user" do
      user = users(:none)
      _(user.permission_sets).must_equal []
      user.add_permission_set("AdminPermissions")
      _(user.permission_sets).must_equal [ "AdminPermissions" ]
    end
  end

  describe "#remove_permission_set" do
    it "removes the permission set from the user" do
      user = users(:admin)
      user.remove_permission_set("AdminPermissions")
      _(user.has_permission_set?("AdminPermissions")).must_equal false
    end

    it "does nothing if the permission set is not in the list" do
      user = users(:none)
      _(user.permission_sets).must_equal []
      user.remove_permission_set("AdminPermissions")
      _(user.permission_sets).must_equal []
    end
  end
end
