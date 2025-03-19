class CreateSettings < ActiveRecord::Migration[8.0]
  def up
    create_table :settings do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.jsonb :values, default: {}
      t.jsonb :schema, null: false

      t.timestamps
    end
  end

  def down
    drop_table :settings
  end
end
