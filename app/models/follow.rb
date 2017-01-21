class Follow < ActiveRecord::Base
  acts_as_tenant(:domain)
  belongs_to :followable, :polymorphic => true, :counter_cache => true
  belongs_to :user
  validates_uniqueness_to_tenant :user_id, :scope => [:followable_id, :followable_type]
  validates :followable_type, :inclusion => { :in => %w[User Forum Topic] }
  attr_accessible :followable_id, :followable_type
  scope :not_by, lambda{ |uid| where('user_id != ?', uid) }
end
