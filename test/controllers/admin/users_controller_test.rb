require "test_helper"

describe Admin::UsersController do
  it "gets index" do
    sign_in users(:admin)
    get admin_users_path
    must_respond_with :success
  end
end
