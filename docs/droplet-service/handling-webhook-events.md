---
layout: default
title: Handling Webhook Events
parent: Creating a Droplet Service
nav_order: 7
---

## Handling Webhook Events

When Fluid needs to notify your Droplet Service it sends webhook events. Each webhook event contains:

1. Two headers for security:
   - `X-Fluid-Shop`: Identifies the company (shop) that owns the resource for the event
   - `AUTH_TOKEN`: Must match the webhook verification token for that shop

2. A JSON payload with two main sections:
   - An outer envelope containing metadata about the event
   - A payload section with the actual event data

### Event Structure

Every webhook event has this outer structure:
```json
{
  "id": "...",
  "identifier": "...",
  "name": "...",
  "payload": { },
  "timestamp": "..."
}
```

#### Outer Fields

`id`
: A unique identifier for this specific webhook event

`identifier`
: The unique identifier of the resource that triggered the event (e.g., `product-123`)

`name`
: The type of event, combining the resource and action (e.g., `product_created`)

`payload`
: Contains the event data and metadata

`timestamp`
: When the event was created (ISO 8601 format)

### Payload Structure

Every payload contains these common fields:
```json
{
  "event_name": "...",
  "company_id": 000,
  "resource_name": "...",
  "resource": "...",
  "event": "..."
}
```

#### Payload Fields

`event_name`
: The event type (e.g., `product_created`)

`company_id`
: The Fluid company ID that owns the resource

`resource_name`
: The human-readable name of the resource (e.g., "Product")

`resource`
: The resource type (e.g., "product")

`event`
: The action performed (e.g., "created")

### Resource Data

After these common fields, the payload includes the resource data itself. For example, a product event includes the product details, an order event includes order details, etc.

### Example: Product Created Event

Here's a complete example of a product creation event:

```json
{
  "id": "12345",
  "identifier": "product-17128358469507",
  "name": "product_created",
  "payload": {
    "event_name": "product_created",
    "company_id": 123,
    "resource_name": "Product",
    "resource": "product",
    "event": "created",
    "product": {
      "id": 789,
      "title": "Example Product",
      "description": "A detailed product description",
      "sku": "PROD-123",
      "upc": "123456789012",
      "hs_code": "1234.56.78",
      "image_url": "https://example.com/images/product.jpg",
      "compressed_image_url": "https://example.com/images/product-compressed.jpg",
      "image_path": "/images/product.jpg",
      "external_url": "https://external-store.com/product",
      "status": "active",
      "price": 99.99,
      "shipping": 5.99,
      "currency_code": "USD",
      "public": true,
      "in_stock": true,
      "keep_selling": true,
      "track_quantity": true,
      "no_index": false,
      "commission": 10.0,
      "affiliate_commission": 5.0,
      "integration_id": "ext-123",
      "external_id": "ext-prod-123",
      "last_synced_at": "2024-03-21T15:30:45Z",
      "metadata": {
        "custom_field": "value"
      },
      "created_at": "2024-03-21T15:30:45Z",
      "updated_at": "2024-03-21T15:30:45Z",
      "variants": [
        {
          "id": 456,
          "title": "Default Variant",
          "sku": "VAR-123",
          "price": 99.99,
          "price_in_currency": "USD 99.99",
          "image_url": "https://example.com/images/variant.jpg",
          "primary_image": "https://example.com/images/variant-primary.jpg"
        }
      ],
      "options": [
        {
          "id": 1,
          "title": "Size",
          "position": 1,
          "presentation": "Size",
          "external_id": "size-1",
          "values": [
            {
              "id": 1,
              "title": "Small",
              "position": 1,
              "presentation": "S"
            },
            {
              "id": 2,
              "title": "Medium",
              "position": 2,
              "presentation": "M"
            }
          ]
        }
      ]
    }
  },
  "timestamp": "2024-03-21T15:30:45Z"
}
```

## Suggested Handling Strategy

1. _Look at the `X-Fluid-Shop` and `AUTH_TOKEN` headers. The auth token should match the webhook verification token for the company with that fluid shop_
2. Sort events by name
3. Validate the event payload structure
4. Check for duplicate events (although duplicates are unlikely)
5. Process the event based on its resource type and priority
6. Use the payload's resource to determine which part of the payload is the resource data
