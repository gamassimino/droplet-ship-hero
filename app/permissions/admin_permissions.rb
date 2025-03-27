module AdminPermissions
  def self.apply(ability:, user:)
    ability.can :manage, :all
  end
end
