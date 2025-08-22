# frozen_string_literal: true

# Register default webhook event handlers.
#
# This is inside a to_prepare block which runs after all application code
# is loaded, making sure the constants are defined when this runs.
# It also runs on every code reload in development, ensuring the handlers
# are always registered.
Rails.application.config.to_prepare do
  # EventHandler.register_handler("company_droplet.created", DropletInstalledJob)
  EventHandler.register_handler("droplet.uninstalled", DropletUninstalledJob)
  EventHandler.register_handler("droplet.installed", DropletInstalledJob)
  EventHandler.register_handler("order.created", OrderCreatedJob)
end
