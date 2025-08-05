class CreateCallbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :callbacks do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :timeout_in_seconds
      t.boolean :active

      t.timestamps
    end
  end
end
