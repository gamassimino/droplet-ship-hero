class Admin::DropletsController < AdminController
  def create
    response = client.droplets.create
    setting = Setting.droplet
    setting.values = response["droplet"].slice("uuid", "name", "active", "embed_url")
    setting.save!

    redirect_to admin_dashboard_index_path, notice: "Droplet created successfully"
  rescue FluidClient::Error => e
    redirect_to admin_dashboard_index_path, alert: "Failed to create droplet: #{e.message}"
  end

  def update
    client.droplets.update
    redirect_to admin_dashboard_index_path, notice: "Droplet created successfully"
  rescue FluidClient::Error => e
    redirect_to admin_dashboard_index_path, alert: "Failed to update droplet: #{e.message}"
  end

private

  def client
    @client ||= FluidClient.new
  end
end
