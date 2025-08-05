---
layout: default
title: Registering the First Callback
parent: Creating a Droplet Service
nav_order: 9
---

## Registering the First Callback

Fluid provides two ways for droplet services to receive information: webhooks and callbacks. While both enable communication between Fluid and your service, they serve different purposes:

- **Webhooks** are like notifications. They tell your service about events that have already happened in Fluid. For example, when a customer updates their cart, Fluid sends a webhook event to notify your service.

- **Callbacks** are like questions. Fluid asks your service for information it needs right now. For example, when a customer adds an item to their cart, Fluid might call your service to ask, "What's the tax rate for this item?"

|    | Webhooks | Callbacks |
|---------|----------|-----------|
| Purpose | Notify about events that have occurred | Request real-time data or actions |
| Timing | Asynchronous (fire and forget) | Synchronous (wait for response) |
| Event Type | Broad system events (e.g., order created, cart updated) | Specific business logic (e.g., tax calculation, shipping rates) |
| HTTP Methods | GET, PUT, or POST | POST only |
| Response | No response required | Must return data in specified format |
| Use Case | Event tracking and logging | Real-time decision making |

### Callbacks in Depth
The callback system consists of two parts:

1. **Callback Definition**: A specification that outlines:
   - What data Fluid will send in the request
   - What format your response must follow
   - Example responses for testing

2. **Callback Registration**: The process of telling Fluid:
   - Which callback you want to handle
   - Where to send the callback requests
   - How to authenticate the requests

For example, here is the definition of the `test_callback_system` callback.
```json
{
  "name": "test_callback_system",
  "description": "Test callback system"
}
```
`name`
: A unique identifier for the callback that you'll use when registering it with Fluid.

`description`
: A clear explanation of the callback's purpose and when it will be triggered.

To register a callback, `POST` an authenticated request to the `/api/callback/registrations` endpoint.

A curl statement would look like this:
```bash
curl -i \
  -X POST https://fluid.app/api/callback/registrations \
  -H 'Authorization: Bearer <DROPLET_INSTALLATION_AUTHENTICATION_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
    "callback_registration": {
      "definition_name": "test_callback_system",
      "url": "https://your-service.com/callbacks",
      "timeout_in_seconds": 12,
      "active": true
    }
  }'
```

`definition_name`
: The callback you're registering

`url`
: The URL Fluid will make a `POST` request to when the callback happens

`timeout_in_seconds`
: How long Fluid should wait for a response to the callback before terminating the request

`active`
: Whether or not a callback is currently in use

**Important**: _You must use a droplet installation token (starts with `dit_`) for authorization, not your company's token. This is because you're creating a callback on behalf of a company that has installed your droplet, not for your own company._

For example:
- Suppose you have a "Reportify" company and droplet service
- "Acme" company installs your droplet
- You want to handle callbacks for Acme's reporting data
- You **must** authenticate with Acme's droplet installation token (`dit_...`), **not** Reportify's company auth token (`C-...`)
- Using Reportify's token would create callbacks for Reportify's data instead of Acme's

A successful response could look like this:
```json
{
  "callback_registration": {
    "uuid": "cbr_wmo5nhb52xniux5pddignpwui1mgox1a",
    "definition_name": "test_callback_system",
    "url": "https://your-service.com/callbacks",
    "timeout_in_seconds": 12,
    "active": true,
    "verification_token": "cvt_1DbieBewYJ0VkIqQzsD1iWtnSrp6nPXTa",
    "created_at": "2021-01-01T00:00:00Z"
  },
  "meta": {
    "request_id": "123e4567-e89b-12d3-a456-426614174000",
    "timestamp": "2021-01-01T00:00:00Z"
  }
}
```

### Testing the Callback

The `test_callback_system` callback is specifically designed to interact with the callback system. It allows you to hit an API endpoint to trigger the callback and see what Fluid is receiving from your callback handler.

It can be done by making a `POST` request to the `/api/callback/test` endpoint.

A curl statement could look like this:
```bash
curl -i \
  -X POST https://fluid.app/api/callback/test \
  -H 'Authorization: Bearer <DROPLET_INSTALLATION_AUTHENTICATION_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{ "message": "Hello World" }'
```

This endpoint does the following things:
1. Verifies that a `test_callback_system` callback is registered for the company associated with the provided droplet installation token
2. Forwards your test message to your callback URL (the one you registered)
3. Waits for your callback service to respond (up to the timeout you specified)
4. Validates that your response matches the expected format defined in the callback definition
5. Returns your callback service's response back to you

For example, if you have a callback service that adds an exclamation mark to messages:
1. You send: `{ "message": "Hello World" }`
2. Your callback service receives this message
3. Your service processes it and returns: `{ "message": "Hello World!" }`
4. The test endpoint validates and returns this response to you

This allows you to verify that your callback service is working correctly before handling real business logic.

More information can be found in [Fluid's Callback Definitions API Documentation](https://fluid-commerce.redocly.app/docs/apis/swagger/callback-definitions) and [Fluid's Callback Registrations API Documentation](https://fluid-commerce.redocly.app/docs/apis/swagger/callback-registrations).
