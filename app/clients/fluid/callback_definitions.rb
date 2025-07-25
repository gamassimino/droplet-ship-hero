module Fluid
  module CallbackDefinitions
    def callback_definitions
      @callback_definitions ||= Resource.new(self)
    end

    class Resource
      def initialize(client)
        @client = client
      end

      def get
        @client.get("/api/callback/definitions")
      end
    end
  end
end
