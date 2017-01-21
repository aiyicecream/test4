class Bookmark < ActiveRecord::Base
  acts_as_tenant(:domain)
  belongs_to :user
  belongs_to :topic
  belongs_to :message
  validates_uniqueness_to_tenant :user_id, :scope => [:topic_id]
end
