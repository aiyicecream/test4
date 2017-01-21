class Notification < ActiveRecord::Base
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  acts_as_tenant(:domain)
  belongs_to :user
  belongs_to :message
  belongs_to :topic
  belongs_to :forum

  after_save :update_notifications_count, :publish
  after_destroy :update_notifications_count

  def self.fire(uid, message)
    Notification.find_or_create_by_user_id_and_message_id_and_topic_id_and_forum_id(uid, message.id, message.topic_id, message.forum_id).touch
  end

  private

  def update_notifications_count
    self.user.update_notifications_count
  end

  def publish
    data = {
      avatar: self.message.user.avatar.exists? ? self.message.user.avatar.url(:x40) : self.message.user.gravatar_url(d: 'retro'),
      title: truncate(self.message.topic.name, length: 20, separator: ' ', omission: '...'),
      content: truncate(self.message.content, length: 24, separator: ' ', omission: '...'),
      count: self.user.notifications_count,
      link: topic_path(self.message.topic) + '?newest'
    }
    PrivatePub.publish_to "/users/#{self.user_id}", data

    # Do not send mail for small_messages
    if self.user_id != self.message.user_id && !self.read && !self.sent && self.user.notify
      # Do not send mail if a mail has been already sent for this topic and user
      if Notification.where(user_id: self.user_id, topic_id: self.topic_id, sent: true, read: false).empty?
        self.update_column :sent, true
        NotificationMailer.instantly(self).deliver
      end
    end
  end
end
