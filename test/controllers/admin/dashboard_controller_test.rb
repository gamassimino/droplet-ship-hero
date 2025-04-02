require "test_helper"

describe Admin::DashboardController do
  it "gets index" do
    Tasks::Settings.create_defaults
    binding.pry
    sign_in users(:admin)
    get admin_dashboard_index_url
    must_respond_with :success
  end
end
