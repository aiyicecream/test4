require 'spec_helper'

feature 'User destroys' do
  scenario "its topic" do
    user = sign_in
    topic = create :topic, user: user

    Capybara.current_session.driver.delete topic_path(topic)
    visit forum_path(topic.forum)
    page.should_not have_content(topic.name)
  end

  scenario "its message" do
    user = sign_in
    topic = create :topic
    message = create :message, user: user

    Capybara.current_session.driver.delete message_path(message)
    visit topic_path(topic)
    page.should_not have_content(message.content)
  end

  scenario "its topic through first message" do
    user = sign_in
    topic = create :topic, user: user

    Capybara.current_session.driver.delete message_path(topic.first_message)
    visit forum_path(topic.forum)
    page.should_not have_content(topic.name)
  end

  scenario "its small message" do
    user = sign_in
    message = create :message
    small_message = create :small_message, user: user, message: message

    Capybara.current_session.driver.delete small_message_path(small_message)
    visit topic_path(message.topic)
    page.should have_content(message.content)
    page.should_not have_content(small_message.content)
  end

  scenario "somebody else small message (should fail)" do
    user = sign_in
    message = create :message
    small_message = create :small_message, message: message

    Capybara.current_session.driver.delete small_message_path(small_message)
    visit topic_path(message.topic)
    page.should have_content(message.content)
    page.should have_content(small_message.content)
  end

  scenario "somebody else topic (should fail)" do
    user = sign_in
    topic = create :topic

    Capybara.current_session.driver.delete topic_path(topic)
    visit forum_path(topic.forum)
    page.should have_content(topic.name)
  end

  scenario "somebody else message (should fail)" do
    user = sign_in
    message = create :message

    Capybara.current_session.driver.delete message_path(message)
    visit topic_path(message.topic)
    page.should have_content(message.content)
  end

  scenario "a forum (should fail)" do
    user = sign_in
    forum = create :forum

    Capybara.current_session.driver.delete forum_path(forum)
    visit forums_path
    page.should have_content(forum.name)
  end

  scenario "its group" do
    user = sign_in
    group = create :group, user: user

    Capybara.current_session.driver.delete group_path(group)
    visit groups_path
    page.should_not have_content(group.name)
  end

  scenario "a group (should fail)" do
    user = sign_in
    group = create :public_group

    Capybara.current_session.driver.delete group_path(group)
    visit groups_path
    page.should have_content(group.name)
  end
end
