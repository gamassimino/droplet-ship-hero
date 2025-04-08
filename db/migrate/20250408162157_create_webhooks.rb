class CreateWebhooks < ActiveRecord::Migration[8.0]
  def change
    create_table :webhooks do |t|
      t.string :resource
      t.string :event
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
