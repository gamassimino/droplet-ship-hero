class AddPermissionsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :permission_sets, :string, array: true, default: []
  end
end
