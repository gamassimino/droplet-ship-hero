---
layout: default
title: What is a Droplet Service?
parent: Creating a Droplet Service
nav_order: 1
---

## What is a Droplet Service?

This documentation is intended to help you integrate your service with the Fluid Platform.

Let's use a hypothetical company, SwiftlyShip, as an example of how that would work.

1. SwiftlyShip needs to create a "SwiftlyShip" company in Fluid's platform to represent their company
1. SwiftlyShip needs to create a "SwiftlyShip" droplet (Fluid integration) to represent their service in the Droplet Marketplace
1. SwiftlyShip needs to handle the activities of companies using their service with Fluid's platform

A **Droplet Service** for the purposes of this documentation would be a service that coordinates Fluid's services with SwiflyShip's services.

```mermaid
stateDiagram-v2
    direction LR

    FluidPlatform --> DropletService : webhook events
    FluidPlatform --> DropletService : callbacks
    DropletService --> FluidPlatform : API calls
    DropletService --> SwiftlyShip : API calls
    SwiftlyShip --> DropletService : API calls

    %% Define color classes
    classDef fluidStyle fill:#0894ff,stroke:#0894ff,color:#FFF
    classDef dropletStyle fill:#c959dd,stroke:#c959dd,color:#FFF
    classDef swiftlyStyle fill:#ff9004,stroke:#ff9004,color:#FFF

    %% Apply styles to entities
    class FluidPlatform fluidStyle
    class DropletService dropletStyle
    class SwiftlyShip swiftlyStyle
```

Here's how an order could flow through the system:

1. <span style="background-color: #0894ff; color: #FFF; padding: 0 3px; border-radius: 4px">FluidPlatform</span> notifies the <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> that an order is ready to ship through an `order_completed` webhook
2. The <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> forwards the order to <span style="background-color: #ff9004; color: #FFF; padding: 0 3px; border-radius: 4px">SwiftlyShip</span> for fulfillment through an API call
3. <span style="background-color: #ff9004; color: #FFF; padding: 0 3px; border-radius: 4px">SwiftlyShip</span> processes the order and notifies the <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> when it ships through an API call
4. The <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> updates the <span style="background-color: #0894ff; color: #FFF; padding: 0 3px; border-radius: 4px">FluidPlatform</span> with the shipping status through an API call and prepares data for the shipping dashboard it will display within Fluid

Here's how shipping costs are calculated when items are added to a cart:

1. <span style="background-color: #0894ff; color: #FFF; padding: 0 3px; border-radius: 4px">FluidPlatform</span> makes a callback request to the <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> when an item is added to a cart
2. The <span style="background-color: #c959dd; color: #FFF; padding: 0 3px; border-radius: 4px">DropletService</span> calculates the shipping cost and responds to the <span style="background-color: #0894ff; color: #FFF; padding: 0 3px; border-radius: 4px">FluidPlatform</span> with the amount
3. The <span style="background-color: #0894ff; color: #FFF; padding: 0 3px; border-radius: 4px">FluidPlatform</span> updates the cart with the new shipping cost

Note: While we show the Droplet Service and SwiftlyShip as separate services in these examples, they could be implemented as a single service. We separate them in our documentation to show their different responsibilities: the Droplet Service coordinates communication with Fluid's platform, while SwiftlyShip manages the core shipping functionality.
