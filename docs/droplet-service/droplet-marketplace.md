---
layout: default
title: The Droplet Marketplace
parent: Creating a Droplet Service
nav_order: 2
---

## The Droplet Marketplace

To understand what a droplet service needs to provide, let's walk through how users discover and install droplets:

1. **Browse Marketplace**: Users start by exploring available droplets in the marketplace
1. **View Details**: When interested in a droplet, users click to see more information
1. **Review Details**: Users can read about features, see screenshots, and learn more
1. **Install**: If they want to use the droplet, users click the install button
1. **Access**: After installation, users can access the droplet from their management page

The information users see comes from different parts of your droplet configuration:

- **Marketplace Listing**: Uses `settings.marketplace_page` for the initial preview
- **Details Page**: Uses `settings.details_page` for comprehensive information
- **Management Page**: Uses `embed_url` to display your service in an iframe

When a user installs your droplet, Fluid sends a `droplet_installed` webhook event to notify your service.
