module Controllable
  extend ActiveSupport::Concern

  included do
    has_many :access_controls, :as => :object, :dependent => :destroy
    attr_accessible :acl_view, :acl_read, :acl_write, :acl_admin

    after_save :save_access_controls

    scope :accessible_for, lambda { |user, access|
      joins(:access_controls).
      where(access_controls: {access: access}).
      where("access_controls.user_type = 'All' or 
        #{user.try(:human) ? "access_controls.user_type = 'Humans' or" : ""}
        (access_controls.user_id = ? and access_controls.user_type = 'User') or 
        (access_controls.user_id IN (?) and access_controls.user_type = 'Group')",
        user.try(:id), user ? user.groups.map(&:id) : []
      ) unless user.try(:sysadmin)
    }
  end

  def prePopulate access
    if access_controls.empty? && access != 'admin'
      return [{id: "{\"type\":\"All\"}", name: I18n.t("acl.all")}].to_json
    end

    access_controls.where(access: access).includes(:object).map do |ac|
      if %w[All Humans].include? ac.user_type
        {id: "{\"type\":\"#{ac.user_type}\"}", name: I18n.t("acl.#{ac.user_type.downcase}")}
      else
        {id: "{\"id\":#{ac.user_id},\"type\":\"#{ac.user_type}\"}", name: ac.user.name}
      end
    end.to_json
  end

  def accessible_for user, access
    user.try(:sysadmin) ||
    access_controls.where(access_controls: {access: access}).
    where("access_controls.user_type = 'All' or 
      #{user.try(:human) ? "access_controls.user_type = 'Humans' or" : ""}
      (access_controls.user_id = ? and access_controls.user_type = 'User') or 
      (access_controls.user_id IN (?) and access_controls.user_type = 'Group')",
      user.try(:id), user ? user.groups.map(&:id) : []
    ).any?
  end

  def save_access_controls
    %w[view read write admin].each do |type|
      begin
        acl = ActiveSupport::JSON.decode('[' + send("acl_#{type}") + ']')
        access_controls.where(access: type).delete_all
        acl.each do |ac|
          if %w[All Humans Group User].include? ac['type']
            access_controls << AccessControl.new(user_id: ac['id'].to_i, user_type: ac['type'], access: type)
          end
        end
      rescue
      end
    end
  end
end
