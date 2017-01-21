require 'spec_helper'

feature 'Visitor visits' do
  scenario 'forums index' do
    forum = create :forum
    visit forums_path
    page.should have_content(forum.name)
    page.should have_xpath "//a[@href='#{forum_path(forum)}']"
  end

  scenario 'a forum topics list' do
    topic = create :topic
    visit forum_path(topic.forum)
    page.should have_content(topic.name)
    page.should have_xpath "//a[@href='#{topic_path(topic)}']"
  end

  scenario 'a topic messages list' do
    message = create :message
    small_message = create :small_message, message: message
    visit topic_path(message.topic)
    page.should have_xpath "//a[@href='#{topic_path(message.topic)}']"
    page.should have_content(message.content)
    page.should have_content(small_message.content)
  end

  scenario 'users index' do
    user = create :user
    visit users_path
    page.should have_content(user.name)
    page.should have_xpath "//a[@href='#{user_path(user)}']"
  end

  scenario 'a profile' do
    user = create :user
    visit user_path(user)
    page.should have_content(user.name)
  end

  scenario '/about static page' do
    visit static_path('about')
  end
end
