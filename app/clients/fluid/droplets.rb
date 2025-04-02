module Fluid
  module Droplets
    def droplets
      @droplets ||= Resource.new(self)
    end

    class Resource
      def initialize(client)
        @client = client
      end

      def get
        @client.get("/api/droplets/#{uuid}")
      end

      def create
        @client.post("/api/droplets", body: payload)
      end

      def update
        @client.put("/api/droplets/#{uuid}", body: payload)
      end

      def delete
        @client.delete("/api/droplets/#{uuid}")
      end

      def payload
        {
          "droplet" => Setting.droplet.values.merge(
            "settings" => {
              "marketplace_page" => Setting.marketplace_page.values,
              "details_page" => Setting.details_page.values,
              "service_operational_countries" => Setting.service_operational_countries.values["countries"],
            },
          ),
        }
      end

      def uuid
        Setting.droplet.uuid
      end
    end
  end
end
