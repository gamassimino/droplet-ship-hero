require "test_helper"

describe Admin::CallbacksController do
  it "gets index" do
    sign_in users(:admin)
    get admin_callbacks_url
    must_respond_with :success
  end

  it "gets show" do
    sign_in users(:admin)
    callback = callbacks(:one)
    get admin_callback_url(callback)
    must_respond_with :success
  end

  it "gets edit" do
    sign_in users(:admin)
    callback = callbacks(:one)
    get edit_admin_callback_url(callback)
    must_respond_with :success
  end

  it "gets update" do
    sign_in users(:admin)
    callback = callbacks(:one)
    patch admin_callback_url(callback), params: {
      callback: {
        url: "https://example.com/updated-callback",
        timeout_in_seconds: 15,
        active: true,
      },
    }
    must_respond_with :redirect
  end

  it "posts sync" do
    sign_in users(:admin)
    post sync_admin_callbacks_url
    must_respond_with :redirect
  end
end
