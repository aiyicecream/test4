require 'spec_helper'

feature 'Admin destroys' do
  scenario "somebody else small message" do
    user = sign_in :admin
    message = create :message
    small_message = create :small_message, message: message

    Capybara.current_session.driver.delete small_message_path(small_message)
    visit topic_path(message.topic)
    page.should have_content(message.content)
    page.should_not have_content(small_message.content)
  end

  scenario "somebody else topic" do
    user = sign_in :admin
    topic = create :topic

    Capybara.current_session.driver.delete topic_path(topic)
    visit forum_path(topic.forum)
    page.should_not have_content(topic.name)
  end

  scenario "somebody else message" do
    user = sign_in :admin
    message = create :message

    Capybara.current_session.driver.delete message_path(message)
    visit topic_path(message.topic)
    page.should_not have_content(message.content)
  end

  scenario "a forum" do
    user = sign_in :admin
    forum = create :forum

    Capybara.current_session.driver.delete forum_path(forum)
    visit forums_path
    page.should_not have_content(forum.name)
  end
end
