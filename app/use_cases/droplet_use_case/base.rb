# frozen_string_literal: true

module DropletUseCase
  class Base
    def self.call(**args)
      new(**args).call
    end

    def initialize(**args)
      args.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def call
      raise NotImplementedError, "#{self.class} must implement #call"
    end

  private

    def success(data = {})
      { success: true }.merge(data)
    end

    def failure(error_message)
      { success: false, error: error_message }
    end

    def droplet_manager
      @droplet_manager ||= DropletManager.new(client)
    end

    def webhook_manager
      @webhook_manager ||= WebhookManager.new(client)
    end

    def client
      @client ||= FluidClient.new
    end
  end
end
