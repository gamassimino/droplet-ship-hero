require "test_helper"

describe HomeController do
  it "gets index" do
    get root_url
    must_respond_with :success
  end
end
