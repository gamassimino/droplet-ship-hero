---
layout: default
title: Creating a Droplet
parent: Creating a Droplet Service
nav_order: 4
---

## Creating a Droplet

To create a droplet through Fluid's API, `POST` an authenticated request to the `/api/droplets` endpoint.

The curl statement would look like this:
```bash
curl -i \
  -X POST https://fluid.app/api/droplets \
  -H 'Authorization: Bearer <COMPANY_API_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
    "droplet": {
      "name": "string",
      "embed_url": "string",
      "settings": {
        "marketplace_page": {
          "title": "string",
          "summary": "string",
          "logo_url": "string"
        },
        "details_page": {
          "title": "string",
          "summary": "string",
          "logo_url": "string",
          "features": [
            {
              "name": "string",
              "summary": "string",
              "details": "string",
              "image_url": "string",
              "video_url": "string"
            }
          ]
        },
        "service_operational_countries": [
          "string"
        ]
      },
      "categories": [
        "string"
      ]
    }
  }'

```

This is an example JSON payload:

```json
{
  "droplet": {
    "name": "Your Droplet Name",
    "embed_url": "https://your-service.com/embed",
    "categories": ["marketing-promotion"],
    "settings": {
      "marketplace_page": {
        "title": "Your Marketplace Title",
        "summary": "A brief description of your droplet",
        "logo_url": "https://your-service.com/logo.png"
      },
      "details_page": {
        "title": "Your Details Page Title",
        "summary": "Detailed description of your droplet",
        "logo_url": "https://your-service.com/logo.png",
        "features": [
          {
            "name": "First Feature",
            "summary": "Brief feature description",
            "details": "Detailed feature description",
            "image_url": "https://your-service.com/feature-image.png"
          }, {
            "name": "Second Feature",
            "summary": "Second feature's summary",
            "details": "Details of the second feature",
            "video_url": "https://your-service.com/feature-video.mp4"
          }
        ]
      },
      "service_operational_countries": ["US", "CA"]
    }
  }
}
```

**Required fields**
`name`
: The name of your droplet

`embed_url`
: The URL that will be shown on the droplet management page once a user has installed your droplet

**Optional fields**
`active`
: Whether or not the droplet can currently be used

`categories`
: An array of categories the droplet belongs to

`settings.marketplace_page`
: Configuration for the marketplace listing
  - `title`: Title shown in the marketplace
  - `summary`: Brief description for the marketplace
  - `logo_url`: URL to your logo that will be shown in the marketplace

`settings.details_page`
: Configuration for the details page
  - `title`: Title shown on the details page
  - `summary`: Detailed description
  - `logo_url`: URL to your logo for the details page
  - `features`: An array of features
    - `name`: Feature name
    - `summary`: Brief feature description
    - `details`: Detailed feature description
    - `image_url`: URL to feature image
    - `video_url`: URL to feature video

`settings.service_operational_countries`
: Array of country codes where your service operates. If this is not defined the service is assumed to be available everywhere.

The API will return a **201** status code with the created droplet data if successful, or a **422** status code with validation errors if the request is invalid.

A successful response could look like this:
```json
{
  "droplet": {
    "uuid": "drp_18zkibs0ugyf8qrd2fanaloxm233qyx28",
    "name": "Reportify",
    "categories": ["Analytics & Reporting"],
    "active": true,
    "publicly_available": false,
    "embed_url": "https://reportify.example.com/embed",
    "settings": {
      "marketplace_page": {
        "title": "Reportify",
        "logo_url": "https://reportify.example.com/logo.png",
        "summary": "a reporting service"
      },
      "details_page": {
        "title": "Reportify",
        "logo_url": "https://reportify.example.com/logo.png",
        "summary": "The best reporting service you can get",
        "features": []
      },
      "service_operational_countries": null
    },
    "created_at": "2019-08-24T14:15:22Z"
  },
  "meta": {
    "request_id": "123e4567-e89b-12d3-a456-426614174000",
    "timestamp": "2021-01-01T00:00:00Z"
  }
}
```

Notice that every droplet that is created is not initially publicly available. This means that the droplet is usable for the company that created it, but not available to other companies' use. To have it available to other companies Fluid can set a droplet to plublicly available "true".

The `uuid` should be saved so track or update the droplet in the future.

More information can be found in [Fluid's Droplet API Documentation](https://fluid-commerce.redocly.app/docs/apis/swagger/droplets).