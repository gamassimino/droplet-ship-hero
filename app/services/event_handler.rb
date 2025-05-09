class EventHandler
  # Stores the mapping of event type (optionally namespaced by version) to handler classes.
  #   { "v1.company_droplet.created" => DropletInstalledJob, ... }
  # HashWithIndifferentAccess is used so callers can pass either String or Symbol keys.
  EVENT_HANDLERS = ActiveSupport::HashWithIndifferentAccess.new

  class << self
    # Public: Routes the given `event_type` to the handler that has been
    # registered for it. If no handler can be found the method will log a
    # warning and return false so that the caller can decide how to respond.
    #
    # event_type - A String like "company_droplet.created". The string can be
    #              prefixed with a version (e.g. "v2.company_droplet.created")
    #              but you can also pass the version in via the `version:` kwarg.
    # *args      - Arguments that will be forwarded to the `perform_later` call
    #              on the job class.
    # version:   - Optional. When supplied the router will look for a mapping
    #              under `"#{version}.#{event_type}"` first and fall back to the
    #              plain event type if that fails.
    #
    # Returns true when a handler was found and the job was enqueued, otherwise
    # false.
    def route(event_type, *args, version: nil)
      key = build_key(event_type, version)

      handler_class = EVENT_HANDLERS[key] || EVENT_HANDLERS[event_type]

      unless handler_class
        Rails.logger.warn("[EventHandler] No handler found for event type: #{key}")
        return false
      end

      # We only support ActiveJob compatible handlers for now. If you want to
      # support PORO handlers you could extend this section.
      if handler_class.respond_to?(:perform_later)
        handler_class.perform_later(*args)
      else
        Rails.logger.error("[EventHandler] Handler #{handler_class} does not respond to `perform_later`.")
        return false
      end

      true
    rescue StandardError => e
      Rails.logger.error("[EventHandler] Error while routing event '#{key}': #{e.class} - #{e.message}")
      false
    end

    # Public: Registers a handler for the given event type.
    #
    # event_type   - String like "company_droplet.created".
    # handler_class- A class that responds to `perform_later` (e.g. an ActiveJob).
    # version:     - Optional version namespace (e.g. "v2"). When supplied the
    #               mapping will be stored under `"#{version}.#{event_type}"`.
    #
    # Examples
    #   EventHandler.register_handler("company_droplet.created", MyJob)
    #   EventHandler.register_handler("company_droplet.created", V2::MyJob, version: "v2")
    def register_handler(event_type, handler_class, version: nil)
      key = build_key(event_type, version)
      EVENT_HANDLERS[key] = handler_class
    end

  private

    # Builds an internal lookup key for the given event_type and optional
    # version.
    def build_key(event_type, version)
      version.present? ? "#{version}.#{event_type}" : event_type.to_s
    end
  end
end
