# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user:)
    (user || User.new).permission_sets.each do |permission_set|
      permission_set.safe_constantize&.apply(ability: self, user: user)
    end
  end
end
