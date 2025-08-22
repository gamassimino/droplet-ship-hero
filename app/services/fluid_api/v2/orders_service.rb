# frozen_string_literal: true

module FluidApi
  module V2
    # Service class that handles order-related API interactions with the Fluid API.
    class OrdersService < BaseService
      def update_order(id:, external_id:)
        response = HTTParty.patch(
          "#{BASE_URL}/v2/orders/#{id}/update_external_id",
          headers: headers,
          body: update_external_id_body(external_id).to_json
        )

        parse_response(response, symbolize_names: true)
      end

      private

      def update_external_id_body(external_id)
        {
          order: {
            external_id: external_id.to_s
          }
        }
      end
    end
  end
end
