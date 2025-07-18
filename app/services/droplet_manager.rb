# frozen_string_literal: true

class DropletManager
  def initialize(client)
    @client = client
  end

  def create
    response = @client.droplets.create
    update_droplet_setting(response["droplet"])
    response["droplet"]
  end

  def update
    @client.droplets.update
  end

private

  attr_reader :client

  def update_droplet_setting(droplet_data)
    setting = Setting.droplet
    setting.values = droplet_data.slice("uuid", "name", "active", "embed_url")
    setting.save!
  end
end
