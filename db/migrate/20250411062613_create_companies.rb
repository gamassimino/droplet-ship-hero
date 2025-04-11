class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :fluid_shop, null: false
      t.string :authentication_token, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :companies, :authentication_token, unique: true
  end
end
