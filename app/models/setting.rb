# frozen_string_literal: true

class Setting < ApplicationRecord
  # OpenAPI 3.1.0 dialect for JSON Schema
  META_SCHEMA = "https://spec.openapis.org/oas/3.1/dialect/base"

  validates :name, presence: true, uniqueness: true
  validate :validate_schema
  validate :validate_values

  def self.method_missing(name, *args, **kwargs, &)
    Tasks::Settings.create_defaults if Setting.count.zero?

    if Setting.exists?(name: name.to_s)
      define_singleton_method(name) { Setting.find_by(name: name.to_s) }

      return send(name)
    end

    super
  end

  def self.respond_to_missing?(name, include_private = false)
    Setting.exists?(name: name.to_s) || super
  end

  def method_missing(name, *args, **kwargs, &)
    value = values[name.to_s]
    return value if value.present?

    super
  end

  def respond_to_missing?(name, include_private = false)
    values.key?(name.to_s) || super
  end

private

  def validate_schema
    return errors.add(:schema, "is missing") if schema.nil?
    return nil if JSONSchemer.valid_schema?(schema, meta_schema: META_SCHEMA)

    JSONSchemer.validate_schema(schema, meta_schema: META_SCHEMA).each do |e|
      errors.add(:schema, e["error"])
    end
  rescue StandardError => e
    Rails.logger.error("Error validating schema: #{e.message}")
    errors.add(:schema, "is invalid")
  end

  def validate_values
    return nil if JSONSchemer.schema(schema, meta_schema: META_SCHEMA).valid?(values)

    JSONSchemer.schema(schema, meta_schema: META_SCHEMA).validate(values).each do |e|
      errors.add(:values, e["error"])
    end
  rescue StandardError => e
    # https://github.com/davishmcclurg/json_schemer/issues/215
    # TODO: Rescue JSONSchemer::SchemaError when it's fixed
    Rails.logger.error("Error validating values: #{e.message}")
    errors.add(:values, "is invalid")
  end
end
