class CreateDefaultSettings < ActiveRecord::Migration[7.2]
  def up
    Tasks::Settings.create_defaults
  end

  def down
    Tasks::Settings.remove_defaults
  end
end
