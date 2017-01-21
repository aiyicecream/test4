class Topic < ActiveRecord::Base
  include ActionView::Helpers
  include Controllable
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :scoped], :scope => :domain_id

  paginates_per 25

  acts_as_tenant(:domain)
  belongs_to :domain, :counter_cache => true
  belongs_to :viewer, :class_name => 'User', :foreign_key => 'viewer_id'
  belongs_to :first_message, :class_name => 'Message', :foreign_key => 'first_message_id'
  belongs_to :last_message, :class_name => 'Message', :foreign_key => 'last_message_id'
  belongs_to :user, :counter_cache => true
  belongs_to :forum, :counter_cache => true, :touch => true
  has_many :messages, :include => [:user], :dependent => :destroy
  has_many :follows, :as => :followable, :dependent => :destroy
  accepts_nested_attributes_for :messages
  validates :name, :presence => true, :length => { :maximum => 64 }
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  validates :forum, :presence => true
  attr_accessible :name, :forum_id, :messages_attributes

  has_many :bookmarks, :dependent => :destroy

  scope :and_stuff, lambda { select('topics.*').includes(:user, :first_message, last_message: [:user]) }

  scope :with_bookmarks, lambda { |user| select('bookmarks.message_id as bookmarked_id').joins("LEFT JOIN bookmarks ON bookmarks.topic_id = topics.id AND bookmarks.user_id = #{user.try(:id)}") if user }

  scope :bookmarked_by, lambda { |user| select('bookmarks.message_id as bookmarked_id').joins("JOIN bookmarks ON bookmarks.topic_id = topics.id AND bookmarks.message_id < topics.last_message_id AND bookmarks.user_id = #{user.try(:id)}") if user }

  scope :with_follows, lambda { |user| select('follows.id as follow_id').joins("LEFT JOIN follows ON followable_id = topics.id AND followable_type = 'Topic' AND follows.user_id = #{user.try(:id)}") if user }

  scope :followed_by, lambda { |user| select('follows.id as follow_id').joins("JOIN follows ON followable_id = topics.id AND followable_type = 'Topic' AND follows.user_id = #{user.try(:id)}") if user }

  scope :child_of, lambda { |forum| where(:forum_id => forum.children.map(&:id) << forum.id) }

  after_update :update_counters
  after_create :autofollow
  after_create :increment_parent_counters, if: :forum
  after_destroy :decrement_parent_counters, if: :forum

  def self.default_column
    'updated_at'
  end

  def self.default_direction column
    %w[follows_count messages_count views_count updated_at].include?(column) ? 'desc' : 'asc'
  end

  def preview
    truncate(first_message.content, length: 100, separator: ' ', omission: '...')
  end

  def last_page
    (messages_count.to_f / Message::PER_PAGE).ceil
  end

  def last_page? page
    last_page == (page||1).to_i
  end

  def viewed_by! user
    if user && user.id != self.viewer_id
      self.update_column :viewer_id, user.id
      self.update_column :views_count, self.views_count+1
    end
  end

  private

  def autofollow
    f = Follow.new(followable_id: id, followable_type: 'Topic')
    f.user_id = user_id
    f.save
  end

  def increment_parent_counters
    if forum.parent_id
      Forum.update_counters forum.parent_id, topics_count: 1
    end
  end

  def decrement_parent_counters
    forum.update_column :last_message_id, forum.all_messages.last.try(:id)
    if forum.parent_id
      Forum.update_counters forum.parent_id, topics_count: -1
      forum.parent.update_column :last_message_id, forum.parent.all_messages.last.try(:id)
    end
  end

  def update_counters
    if forum_id_changed?
      messages.update_all forum_id: forum_id
      was = Forum.find(forum_id_was)

      if was.last_message_id == last_message_id
        was.update_column :last_message_id, was.all_messages.last.try(:id)
      end

      if was.parent_id && was.parent.last_message_id == last_message_id
        was.parent.update_column :last_message_id, was.parent.all_messages.last.try(:id)
      end

      if forum.last_message_id < last_message_id
        forum.update_column :last_message_id, last_message_id
      end

      if forum.parent_id && forum.parent.last_message_id < last_message_id
        forum.parent.update_column :last_message_id, last_message_id
      end

      Forum.update_counters forum_id_was, topics_count: -1, messages_count: -messages_count
      Forum.update_counters forum_id, topics_count: 1, messages_count: messages_count
      Forum.update_counters was.parent_id, topics_count: -1, messages_count: -messages_count if was.parent_id
      Forum.update_counters forum.parent_id, topics_count: 1, messages_count: messages_count if forum.parent_id
    end
  end
end
