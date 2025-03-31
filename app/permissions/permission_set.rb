class PermissionSet
  @@descendants = []

  class << self
    def inherited(subclass)
      @@descendants << subclass
    end

    def descendants
      load_descendants if @@descendants.empty?
      @@descendants.dup
    end

    def apply(ability:, user:)
      raise NotImplementedError, "Subclasses must implement the apply method"
    end

    def load_descendants
      Dir[Rails.root.join("app/permissions/**/*.rb")].each { |file| require_dependency file }
    end
  end
end
