require "test_helper"

describe FluidClient do
  describe "#payload" do
    it "returns a valid payload" do
      Tasks::Settings.create_defaults
      client = FluidClient.new

      _(client.droplets.payload).must_equal({
        "droplet" => {
          "name" => "Existing Droplet",
          "uuid" => "existing-uuid",
          "active" => true,
          "embed_url" => "https://example.com/existing",
          "settings" => {
            "marketplace_page" => {
              "title" => "Marketplace Title",
              "logo_url" => nil,
              "summary" => nil,
            },
            "details_page" => {
              "title" => "Details Title",
              "logo_url" => nil,
              "summary" => nil,
            },
            "service_operational_countries" => [],
          },
        },
      })
    end
  end
end
