class AdminPermissions < PermissionSet
  def self.apply(ability:, user:)
    ability.can :manage, :all
  end
end
