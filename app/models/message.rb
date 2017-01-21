class Message < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Spammable
  include Renderable

  has_paper_trail :only => [:content]
  has_attached_file :attachment
  validates_attachment_size :attachment, :less_than => 1.megabyte

  PER_PAGE = 20
  paginates_per PER_PAGE

  acts_as_tenant(:domain)
  belongs_to :domain, :counter_cache => true
  has_many :notifications, :dependent => :destroy
  has_many :small_messages, :dependent => :destroy
  belongs_to :updater, :class_name => 'User', :foreign_key => 'updater_id'
  belongs_to :user, :counter_cache => true
  belongs_to :topic, :counter_cache => true, :touch => true
  belongs_to :forum, :counter_cache => true, :touch => true
  validates :content, :presence => true, :length => { :maximum => 32768 }
  attr_accessible :content, :attachment, :topic_id

  scope :and_stuff, lambda { select('messages.*').includes(:user, :updater, :small_messages => :user) }

  scope :graph, lambda { select(['date(created_at) as date', 'count(id) as value']).group('date') }
  scope :graph_follows, lambda { select(['date(created_at) as date', 'sum(follows_count) as value']).where('follows_count > ?', 0).group('date') }

  mapping do
    indexes :id, :index => :not_analyzed
    indexes :content, :analyzer => 'snowball'
    indexes :topic, :as => 'topic.try(:name)', :analyzer => 'snowball'
    indexes :forum, :as => 'forum.try(:name)', :analyzer => 'snowball'
    indexes :domain, :as => 'domain.try(:name)', :analyzer => 'snowball'
    indexes :user, :as => 'user.try(:name)', :analyzer => 'snowball'
    indexes :at, :as => 'created_at', :type => 'date'
  end

  before_save :set_parents
  after_create :autofollow
  after_create :update_parents, if: :topic
  after_destroy :decrement_parent_counters, if: :topic
  after_save :fire_notifications

  private

  def autofollow
    Follow.find_or_create_by_followable_type_and_followable_id_and_user_id('Topic', topic_id, user_id)
  end

  def update_parents
    topic.first_message_id = id unless topic.first_message_id
    topic.last_message_id = id
    topic.save
    forum.update_column :last_message_id, id
    if forum.parent_id
      Forum.update_counters forum.parent_id, messages_count: 1
      forum.parent.update_column :last_message_id, id
    end
  end

  def decrement_parent_counters
    if last_message_id = topic.messages.last.try(:id)
      if id == topic.last_message_id
        topic.update_column :last_message_id, last_message_id
        if id == forum.last_message_id
          forum.update_column :last_message_id, forum.all_messages.last.try(:id)
          forum.parent.update_column :last_message_id, forum.parent.all_messages.last.try(:id) if forum.parent
        end
      end
    end
    if forum.parent
      Forum.update_counters forum.parent_id, messages_count: -1
    end
  end

  def set_parents
    self.forum = Topic.find(topic_id).forum
  end

  def fire_notifications
    @user_ids.each do |uid|
      if uid != self.user_id
        Notification.fire(uid, self)
      end
    end
    Follow.not_by(self.user_id).where(:followable_id => self.user_id, :followable_type => 'User').each do |f|
      Notification.fire(f.user_id, self)
    end
    Follow.not_by(self.user_id).where(:followable_id => self.topic_id, :followable_type => 'Topic').each do |f|
      Notification.fire(f.user_id, self)
    end
    if self.topic.messages_count == 0
      Follow.not_by(self.user_id).where(:followable_id => self.forum_id, :followable_type => 'Forum').each do |f|
        Notification.fire(f.user_id, self)
      end
    end
  end

end
