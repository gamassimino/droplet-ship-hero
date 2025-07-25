module Fluid
  module CallbackRegistrations
    def callback_registrations
      @callback_registrations ||= Resource.new(self)
    end

    class Resource
      def initialize(client)
        @client = client
      end

      def get(params = {})
        query_string = build_query_string(params)
        @client.get("/api/callback/registrations#{query_string}")
      end

      def create(attributes = {})
        @client.post("/api/callback/registrations", body: payload(attributes))
      end

      def show(uuid)
        @client.get("/api/callback/registrations/#{uuid}")
      end

      def update(uuid, attributes = {})
        @client.put("/api/callback/registrations/#{uuid}", body: payload(attributes, uuid))
      end

      def delete(uuid)
        @client.delete("/api/callback/registrations/#{uuid}")
      end

      def payload(attributes = {}, uuid = nil)
        payload_data = {
          "callback_registration" => {
            "definition_name" => attributes[:definition_name],
            "url" => attributes[:url],
            "timeout_in_seconds" => attributes.key?(:timeout_in_seconds) ? attributes[:timeout_in_seconds] : 20,
            "active" => attributes.key?(:active) ? attributes[:active] : true,
          },
        }

        payload_data["uuid"] = uuid if uuid

        payload_data
      end

    private

      def build_query_string(params)
        return "" if params.empty?

        query_params = []
        query_params << "active=#{params[:active]}" if params.key?(:active)
        query_params << "company_id=#{params[:company_id]}" if params.key?(:company_id)
        query_params << "definition_name=#{params[:definition_name]}" if params.key?(:definition_name)
        query_params << "page=#{params[:page]}" if params.key?(:page)
        query_params << "per_page=#{params[:per_page]}" if params.key?(:per_page)
        query_params << "sorted_by=#{params[:sorted_by]}" if params.key?(:sorted_by)

        "?#{query_params.join('&')}"
      end
    end
  end
end
