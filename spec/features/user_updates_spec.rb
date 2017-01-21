require 'spec_helper'

feature 'User updates' do
  scenario "its group" do
    user = sign_in
    group = create :group, user: user

    visit groups_path
    page.find(:xpath, "//a[@href='#{edit_group_path(group)}']").click
    fill_in 'Name', with: 'Group updated'
    find('.btn-primary').click
    page.should have_content('Group updated')
  end

  scenario "somebody else group" do
    user = sign_in
    other = create :user
    group = create :group, user: other

    visit groups_path
    page.should_not have_xpath "//a[@href='#{edit_group_path(group)}']"
    visit edit_group_path(group)
    current_path.should_not == edit_group_path(group)
  end

  scenario "its topic" do
    user = sign_in
    topic = create :topic, user: user

    visit topic_path(topic)
    page.find(:xpath, "//a[@href='#{edit_topic_path(topic)}']").click
    fill_in 'Title', with: 'Topic updated'
    find('.btn-primary').click
    page.should have_content('Topic updated')
  end

  scenario "its message" do
    user = sign_in
    message = create :message, user: user

    visit topic_path(message.topic)
    page.find(:xpath, "//a[@href='#{edit_message_path(message)}']").click
    fill_in 'Message', with: 'Message updated'
    find('.btn-primary').click
    page.should have_content('Message updated')
  end

  scenario "somebody else topic (should fail)" do
    user = sign_in
    topic = create :topic

    visit topic_path(topic)
    page.should_not have_xpath "//a[@href='#{edit_topic_path(topic)}']"
    visit edit_topic_path(topic)
    current_path.should_not == edit_topic_path(topic)
  end

  scenario "somebody else message (should fail)" do
    user = sign_in
    message = create :message

    visit topic_path(message.topic)
    page.should_not have_xpath "//a[@href='#{edit_message_path(message)}']"
    visit edit_message_path(message)
    current_path.should_not == edit_message_path(message)
  end

  scenario "a forum (should fail)" do
    user = sign_in
    forum = create :forum

    visit forum_path(forum)
    page.should_not have_xpath "//a[@href='#{edit_forum_path(forum)}']"
    visit edit_forum_path(forum)
    current_path.should_not == edit_forum_path(forum)
  end
end
