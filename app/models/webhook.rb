class Webhook < ApplicationRecord
  # NOTE: The events are the same as the ones in the Fluid API
  # https://docs.fluid.app/docs/apis/fluid.api/webhooks
  RESOURCE_EVENTS = HashWithIndifferentAccess.new({
    cart: %w[ abandoned updated ],
    contact: %w[ created updated ],
    event: %w[ created updated deleted ],
    order: %w[ cancelled completed updated shipped refunded ],
    popup: %w[ submitted ],
    product: %w[ created updated destroyed ],
    subscription: %w[ started paused cancelled ],
    user: %w[ created updated deactivated],
  }).freeze

  validates :resource, inclusion: RESOURCE_EVENTS.keys
  validates :event, inclusion: { in: ->(record) { RESOURCE_EVENTS.fetch(record.resource, []) } }
end
