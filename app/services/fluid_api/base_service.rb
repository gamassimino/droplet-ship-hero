# frozen_string_literal: true

module FluidApi
  class BaseService
    attr_reader :company_token

    BASE_URL = 'https://api.fluid.app/api'

    def initialize(company_token)
      @company_token = company_token
    end

    def headers
      {
        'Authorization' => "Bearer #{company_token}",
        'Content-Type' => 'application/json',
        'x-fluid-client' => 'droplet-shipstation'
      }
    end

    def parse_response(response, symbolize_names: false)
      JSON.parse(response.body, symbolize_names:)
    rescue JSON::ParserError => e
      Rails.logger.error("[ERROR][parse_response]: #{e.message}")
      raise
    end
  end
end
