  ## Event Handler System

This application includes a flexible event handling system that routes incoming webhook events to the appropriate job handlers. The system is designed to be configurable, extensible, and supports versioning.

### How It Works

The `EventHandler` class provides a registry of event types to handler classes and a routing mechanism:

```ruby
EventHandler.route("company_droplet.created", payload)
```

When an event is routed, the corresponding handler is found and enqueued as a background job.

### Registering Event Handlers

The default event handlers are registered in `config/initializers/event_handler.rb`. You can register custom handlers either in this file or at runtime:

```ruby
# Register a standard handler
EventHandler.register_handler("custom.event", CustomEventJob)

# Register a versioned handler
EventHandler.register_handler("api.event", V2ApiEventJob, version: "v2")
```

### Versioning Support

The system supports versioned event handlers:

```ruby
# Route to a specific version
EventHandler.route("api.event", payload, version: "v2")

# Or use fully qualified event name
EventHandler.route("v2.api.event", payload)
```

When a version is specified but no handler is found for that version, the system falls back to the unversioned handler if available.

### Custom Event Handlers

To add a custom event handler:

1. Create a job class that inherits from `ApplicationJob`
2. Register it with the EventHandler
3. Your job class should expect to receive the payload in its `perform` method

Example:

```ruby
class CustomEventJob < ApplicationJob
  queue_as :default

  def perform(payload)
    # Process the event payload
  end
end

# Register the handler
EventHandler.register_handler("custom.event", CustomEventJob)
```

### Testing Events

The event handling system includes comprehensive tests:

- `test/services/event_handler_test.rb` - Tests for the EventHandler class
- `test/jobs/*_job_test.rb` - Tests for individual job handlers

See these test files for examples of how to test your own event handlers.
