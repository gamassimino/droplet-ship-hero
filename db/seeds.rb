Setting.find_or_create_by!(name: "droplet") do |setting|
  setting.description = "Name and embed URL for the Droplet"
  setting.schema = {
    type: "object",
    required: [ "name" ],
    properties: {
      name: {
        type: "string",
      },
      embed_url: {
        type: %w[string null],
      },
    },
  }
  setting.values = {
    name: "Placeholder",
  }
end

Setting.find_or_create_by!(name: "marketplace_page") do |setting|
  setting.description = "Values for the Droplet Marketplace Page"
  setting.schema = {
    type: "object",
    required: [ "title" ],
    properties: {
      title: {
        type: "string",
      },
      logo_url: {
        type: %w[string null],
      },
      summary: {
        type: %w[string null],
      },
    },
  }
  setting.values = {
    title: "Placeholder",
  }
end

Setting.find_or_create_by!(name: "details_page") do |setting|
  setting.description = "Values for the Droplet Details Page"
  setting.schema = {
    "title" => "Droplet::DetailsPage",
    "type" => "object",
    "properties" => {
      "title" => { "type" => "string" },
      "logo_url" => { "type" => %w[string null] },
      "summary" => { "type" => %w[string null] },
      "features" => {
        "type" => %w[array null],
        "items" => {
          "title" => "Droplet::Feature",
          "type" => "object",
          "properties" => {
            "name" => { "type" => "string" },
            "summary" => { "type" => %w[string null] },
            "details" => { "type" => %w[string null] },
            "image_url" => { "type" => %w[string null] },
            "video_url" => { "type" => %w[string null] },
          },
          "required" => %w[name],
        },
      },
    },
    "required" => %w[title],
  }
  setting.values = {
    title: "Placeholder",
  }
end
