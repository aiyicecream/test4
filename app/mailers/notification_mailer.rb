class NotificationMailer < ActionMailer::Base
  def instantly(notification)
    @notification = notification
    if @notification.message.domain
      mail(:from => "#{@notification.message.domain.title} <notifications@#{@notification.message.domain.name}>", :to => @notification.user.email, :subject => t('mailer.title', topic: @notification.message.topic.name))
    end
  end
end
