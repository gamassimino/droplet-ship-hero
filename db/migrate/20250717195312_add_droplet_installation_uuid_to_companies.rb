class AddDropletInstallationUuidToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :droplet_installation_uuid, :string
  end
end
