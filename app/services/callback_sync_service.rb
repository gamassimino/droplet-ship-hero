class CallbackSyncService
  def initialize
    @client = FluidClient.new
  end

  def sync
    begin
      response = @client.callback_definitions.get

      if response&.dig("definitions")&.any?
        sync_callbacks(response["definitions"])
        { success: true, message: "Successfully synced #{response['definitions'].length} callbacks" }
      else
        { success: false, message: "No callback definitions found" }
      end
    rescue => e
      Rails.logger.error "Callback sync failed: #{e.message}"
      { success: false, message: "Sync failed: #{e.message}" }
    end
  end

private

  def sync_callbacks(definitions)
    definitions.each do |definition|
      create_or_update_callback(definition)
    end
  end

  def create_or_update_callback(definition)
    callback = Callback.find_or_initialize_by(name: definition["name"])

    callback.assign_attributes(
      description: definition["description"],
      active: false
    )

    callback.save!
  rescue => e
    Rails.logger.error "Failed to sync callback #{definition['name']}: #{e.message}"
  end
end
