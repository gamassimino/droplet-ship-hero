class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :identifier
      t.string :name
      t.jsonb :payload, default: {}
      t.datetime :timestamp
      t.integer :status

      t.timestamps
    end

    add_index :events, :identifier
    add_index :events, :name
  end
end
