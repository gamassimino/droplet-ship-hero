# frozen_string_literal: true

module DropletUseCase
  class Create < Base
    def call
      ActiveRecord::Base.transaction do
        droplet_data = droplet_manager.create
        webhook_data = webhook_manager.create

        success(droplet: droplet_data, webhook: webhook_data)
      end
    rescue FluidClient::Error => e
      failure(e.message)
    end
  end
end
