# Class Ability, to determine the permissions each role
class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role.name.downcase) }
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def admin
    can :manage, all
  end

  def trader
    # can :read, User, :user_id = user.id
    # (a) can :update, Profile, :registration_state == "authorized?"
    can [:create, :read], Order
    can :read, User
  end

  def authorized_provider
    cannot :manage, all
  end

  # tracer
  # can update user (proveedor) authorized
  # can [purchase, sale, ] create read   <--
  # can read inventory---------------------|
  # courier only will be created by admin
  # A trader just can update provider when created and registration_status in "inicialized"(a)
  # rucoms public, just read
  # depende of role, trader [cannot create or delete user, (a)can update provider]

  # future
  # TO DO a trader have access to own credit_billing.
end
