class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :fluid_shop, null: false
      t.string :authentication_token, null: false
      t.string :name, null: false
      t.jsonb :settings, default: {}
      t.string :webhook_verification_token
      t.bigint :fluid_company_id, null: false
      t.string :service_company_id
      t.string :company_droplet_uuid
      t.boolean :active, default: false
      t.datetime :uninstalled_at

      t.timestamps
    end

    add_index :companies, :authentication_token, unique: true
    add_index :companies, :fluid_shop
    add_index :companies, :fluid_company_id
    add_index :companies, :company_droplet_uuid
    add_index :companies, :active
  end
end
