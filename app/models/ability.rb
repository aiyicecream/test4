class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Forum do |o|
      o.accessible_for(user, 'read')
    end

    can :read, Topic do |o|
      o.forum.accessible_for(user, 'read') &&
      o.accessible_for(user, 'read')
    end

    can :read, Message do |o|
      o.forum.accessible_for(user, 'read') &&
      o.topic.accessible_for(user, 'read')
    end

    can :read, Domain # unused
    can :read, SmallMessage # unused
    can :read, User # unused

    unless user.new_record?
      can :manage, Domain do |o|
        user.sysadmin?
      end
      can [:manage, :position], Forum do |o|
        user.sysadmin? ||
        o.accessible_for(user, 'admin')
      end
      can :create, Topic do |o|
        (user.human? || user.topics.empty? || user.sysadmin?) &&
        o.forum.accessible_for(user, 'write')
      end
      can [:update, :destroy], Topic do |o|
        user.id == o.user_id || user.sysadmin? ||
        o.accessible_for(user, 'admin') ||
        o.forum.accessible_for(user, 'admin')
      end
      can :pin, Topic do |o|
        user.sysadmin? ||
        o.forum.accessible_for(user, 'admin')
      end
      can :create, Message do |o|
        (user.human? || user.messages.empty? || user.sysadmin?) &&
        o.topic.accessible_for(user, 'write') &&
        o.topic.forum.accessible_for(user, 'write')
      end
      can [:update, :destroy], Message do |o|
        user.id == o.user_id || user.sysadmin? ||
        o.topic.user_id == user.id ||
        o.topic.accessible_for(user, 'admin') ||
        o.topic.forum.accessible_for(user, 'admin')
      end
      can :history, Message do |o|
        user.sysadmin? || o.forum.accessible_for(user, 'admin')
      end
      can :create, SmallMessage do |o|
        user.human? ||
        user.sysadmin?
      end
      can [:update, :destroy], SmallMessage do |o|
        user.id == o.user_id || user.sysadmin? ||
        o.message.user_id == user.id ||
        o.message.topic.user_id == user.id ||
        o.message.topic.accessible_for(user, 'admin') ||
        o.message.forum.accessible_for(user, 'admin')
      end
      can :manage, Bookmark do |o|
        user.id == o.user_id
      end
      can :create, Follow
      can :manage, Follow do |o|
        user.id == o.user_id
      end
      can :read, Notification
      can :manage, Notification do |o|
        user.id == o.user_id
      end
      can [:read, :create], Group
      can :manage, Group do |o|
        o.user_id == user.id || user.sysadmin?
      end
      can :manage, User do |o|
        user.sysadmin?
      end
      can :bot, User do |o|
        !o.human &&
        (user.sysadmin? || o.messages.last.forum.accessible_for(user, 'admin'))
      end
    end
  end
end
