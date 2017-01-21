class AccessControl < ActiveRecord::Base
  belongs_to :object, :polymorphic => true
  belongs_to :user, :polymorphic => true
  validates :access, :inclusion => { :in => %w[view read write admin] }, :allow_blank => false
  attr_accessible :access, :object_id, :object_type, :user_id, :user_type
end
