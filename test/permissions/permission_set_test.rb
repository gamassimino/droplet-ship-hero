require "test_helper"

describe PermissionSet do
  describe "when a subclass is inherited" do
    it "tracks the descendants" do
      # load the subclass so that it shows up in the descendants array
      test_sets = [ AdminPermissions ]
      _(PermissionSet.descendants.intersection(test_sets)).must_equal test_sets
    end
  end
end
