class Forum < ActiveRecord::Base
  include Controllable

  acts_as_tenant(:domain)
  belongs_to :domain, :counter_cache => true
  default_scope order(:position, :parent_id, :slug)

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :scoped], :scope => :domain_id

  has_many :children, :class_name => 'Forum', :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => 'Forum', :foreign_key => 'parent_id', :touch => true
  has_many :topics, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  belongs_to :last_message, :class_name => 'Message', :foreign_key => 'last_message_id'
  validates :name, :presence => true, :length => { :maximum => 64 }
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  validates :content, :length => { :maximum => 32768 }

  scope :with_follows, lambda { |user| select('follows.id as follow_id').joins("LEFT JOIN follows ON followable_id = forums.id AND followable_type = 'Forum' AND follows.user_id = #{user.try(:id)}") if user }

  attr_accessible :content, :name, :parent_id

  after_save :touch_parent, :if => :parent_id_was

  def all_topics
    Topic.child_of(self)
  end

  def all_messages
    Message.where(:forum_id => children.map(&:id) << id)
  end

  private

  def touch_parent
    Forum.find(parent_id_was).touch
  end
end
