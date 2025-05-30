---
layout: default
title: Creating a Company
parent: Creating a Droplet Service
nav_order: 3
---

## Creating a Company

A company can be created through [Fluid's sign-up page](https://admin.fluid.app/sign-up).

Alternatively, a company can be created through the API through a `POST` to the `/api/company` endpoint.

A curl statement could look like this:
```bash
curl -i \
  -X POST https://fluid.app/api/company \
  -H 'Content-Type: application/json' \
  -d '{
  "user": {
    "first_name": "John",
    "last_name": "D`oh",
    "email": "john@swiftlyship.com",
    "password": "myvoiceismypassportverifyme"
  },
  "company": {
    "name": "SwiftlyShip",
    "subdomain": "swiftly-ship"
  }
}'
```

The user information creates the company's administrator. The company's subdomain (e.g., `swiftly-ship.fluid.app`) serves as its unique identifier in the Fluid platform and is referred to as the "fluid shop".

Sign to the admin's account at `https://admin.fluid.app`.

### Accessing the API

<img src="/droplet-template/images/developer-menu.png" alt="Developer Menu" width="240" style="float: left; margin-right: 1rem">

After signing in to your account, you'll need to access the developer section to access your API credentials. To do this, look for the "Developer" option in the menu located in the lower left section of the dashboard.

<p style="clear: both; padding-top: 1rem">
Scroll down until you come to the API Token section. This API token will be needed for authenticating API requests when making them on behalf of your company.
</p>
<img src="/droplet-template/images/company-api-token.png">
