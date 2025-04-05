class FluidClient
  include HTTParty
  include Fluid::Droplets

  base_uri Setting.fluid_api.base_url
  headers "Authorization" => "Bearer #{Setting.fluid_api.api_key}", "Content-Type" => "application/json"
  format :json

  Error                 = Class.new(StandardError)
  AuthenticationError   = Class.new(Error)
  ResourceNotFoundError = Class.new(Error)
  APIError              = Class.new(Error)

  def initialize
    @http = self.class
  end

  def get(path, options = {})
    handle_response(@http.get(path, format_options(options)))
  end

  def post(path, options = {})
    handle_response(@http.post(path, format_options(options)))
  end

  def put(path, options = {})
    handle_response(@http.put(path, format_options(options)))
  end

  def delete(path, options = {})
    handle_response(@http.delete(path, format_options(options)))
  end

private

  def format_options(options)
    options[:body] = options[:body].to_json if options[:body].is_a?(Hash)

    options
  end

  def handle_response(response)
    case response.code
    when 200..299
      response.parsed_response
    when 401
      raise AuthenticationError, response
    when 404
      raise ResourceNotFoundError, response
    else
      raise APIError, response
    end
  end
end
