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
  "description": "Test callback system",
  "example_response": {
    "message": "Hello, world!"
  },
  "request_schema": {
    "type": "object",
    "properties": {
      "message": {
        "type": "string",
        "description": "Message to be sent"
      }
    },
   "required": ["message"]
  },
  "response_schema": {
    "type": "object",
    "properties": {
      "message": {
        "type": "string",
        "description": "Message to be received"
      }
    },
    "required": ["message"]
  }
}
```
`name`
: A unique identifier for the callback that you'll use when registering it with Fluid.

`description`
: A clear explanation of the callback's purpose and when it will be triggered.

`example_response`
: A sample response that demonstrates the expected format and data structure.

`request_schema`
: A [JSON schema](https://json-schema.org/) that defines the format of the callback request from Fluid.

`response_schema`
: A [JSON schema](https://json-schema.org/) that defines the required format for your callback response.

More information can be found in [Fluid's Callback Definition API Documentation](https://fluid-commerce.redocly.app/docs/apis/swagger/callback-definitions).
