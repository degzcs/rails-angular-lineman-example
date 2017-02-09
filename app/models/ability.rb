# Class Ability, to determine the permissions each role
class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role.name.downcase) }
  end

  def admin
    can :manage, :all
  end

  def trader
    # can :read, User, :user_id = user.id
    # (a) can :update, Profile, :registration_state == "authorized?"
    can [:create, :read], Order do |order, remote_ip|
     order.seller_id == @user.id || order.buyer_id == @user.id
    end

    # Allow office read their own orders
    can [:read], Order do |order, remote_ip|
     order.audits.where(action: 'create').first.user_id == @user.id
    end

    can :read, User
    can :read, Settings
  end

  def authorized_provider
    cannot :manage, :all
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
