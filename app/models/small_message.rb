class SmallMessage < ActiveRecord::Base
  include Spammable

  acts_as_tenant(:domain)
  belongs_to :message
  belongs_to :user
  belongs_to :topic
  belongs_to :forum
  attr_accessible :content, :message_id
  validates :content, :presence => true, :length => { :maximum => 140 }

  before_save :set_parents
  after_save :fire_notifications

  private

  def set_parents
    self.forum = message.forum
    self.topic = message.topic
  end

  def fire_notifications
    (self.message.small_messages.map(&:user_id) << self.message.user_id).uniq.reject{|uid| uid == self.user_id}.each do |uid|
      Notification.find_or_create_by_user_id_and_message_id(uid, self.message_id).touch
    end
  end
end
