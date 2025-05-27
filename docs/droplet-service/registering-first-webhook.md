---
layout: default
title: Registering the First Webhook
parent: Creating a Droplet Service
nav_order: 6
---

## Registering the First Webhook

Webhooks keep your service informed about what's happening in Fluid. Here's how they work:

1. **Automatic Notifications**: Fluid sends a message to your service whenever something important happens
2. **No Polling Needed**: Your service doesn't need to keep checking for updates

For example, when someone installs your droplet, you'll want to know about it. To receive these notifications:

1. Register a webhook for the `droplet_installed` event
2. Provide the URL where you want to receive notifications
3. Handle the incoming webhook requests

To register your first webhook, send a `POST` request to `/api/webhooks` with your configuration.

A curl statement would look like this:
```bash
curl -i \
  -X POST https://fluid.app/api/webhooks \
  -H 'Authorization: Bearer <COMPANY_API_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
        "webhook": {
          "resource": "droplet",
          "event": "installed",
          "url": "https://reportify.example.com/webhook",
          "active": true,
          "http_method": "post"
        }
      }'
```

To receive webhooks, you'll need to:

1. Set up a secure HTTPS endpoint on your server
2. Make sure it can handle POST requests
3. Configure it to process the webhook event payload

For example, when someone installs your droplet, Fluid could send a POST request to your endpoint with information about the installation. Here's what that payload might look like:

```json
{
  "event_name": "droplet_installed",
  "company_id": 197736325,
  "resource_name": "Droplet",
  "resource": "droplet",
  "event": "installed",
  "company": {
    "authentication_token": "dit_n9F8NmwVzaKiCMDRAN4FBsj8jlvR0I31",
    "droplet_installation_uuid": "dri_ssklg1e12jewefxfrorx92v317t0b2ho",
    "droplet_uuid": "drp_16qsoxymym9u3fjm2x7bjm6bilpt1qlzd",
    "fluid_company_id": 226157151,
    "fluid_shop": "fluid.fluid.app",
    "name": "Fluid",
    "webhook_verification_token": "wvt_1vGG3sDMABi5jQ0z5OYnD4gcpn92trvnk"
  }
}
```
When a droplet is installed a "droplet_installation" is created to track it.

**General Webhook Attributes**

- `authentication_token`: Use this token to make API calls on behalf of the company that installed your droplet
- `droplet_installation_uuid`: Unique identifier for this specific installation of your droplet
- `droplet_uuid`: Unique identifier of your droplet. If you have multiple droplets, this can be used to track which one was installed
- `fluid_company_id`: Fluid's internal ID for the company that installed your droplet
- `fluid_shop`: The company's subdomain on the Fluid platform (e.g., "mycompany.fluid.app"). It relates to analytics and tracking
- `name`: The name of the company that installed your droplet
- `webhook_verification_token`: Use this token to verify that webhook events are actually sent by Fluid

More information can be found in [Fluid's Webhook API Documentation](https://fluid-commerce.redocly.app/docs/apis/swagger/webhooks).
