# frozen_string_literal: true

module DropletUseCase
  class Update < Base
    def call
      ActiveRecord::Base.transaction do
        droplet_manager.update
        webhook_data = webhook_manager.update

        success(webhook: webhook_data)
      end
    rescue FluidClient::Error => e
      failure(e.message)
    end
  end
end
