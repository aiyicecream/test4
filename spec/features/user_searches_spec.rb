require 'spec_helper'

feature 'User searches' do
  scenario "a message" do
    user = sign_in
    message = create :message
    sleep 1

    visit messages_path(q: "\"#{message.content}\"")
    page.should have_content(message.content)
  end

  scenario "a message by topic name" do
    user = sign_in
    message = create :message
    sleep 1

    visit messages_path(q: "topic:\"#{message.topic.name}\"")
    page.should have_content(message.content)
  end

  scenario "a message by forum name" do
    user = sign_in
    message = create :message
    sleep 1

    visit messages_path(q: "forum:\"#{message.forum.name}\"")
    page.should have_content(message.content)
  end

  scenario "a message by user name" do
    user = sign_in
    message = create :message
    sleep 1

    visit messages_path(q: "user:\"#{message.user.name}\"")
    page.should have_content(message.content)
  end

  scenario "an anonymous message" do
    user = sign_in
    message = create :message
    content = message.content
    message.user.destroy
    sleep 1

    visit messages_path(q: "\"#{content}\"")
    page.should have_content(content)
  end

  scenario "a deleted message (should fail)" do
    user = sign_in
    message = create :message
    content = message.content
    message.destroy
    sleep 1

    visit messages_path(q: "\"#{content}\"")
    page.should_not have_content(content)
  end

  scenario "a message deleted through topic (should fail)" do
    user = sign_in
    message = create :message
    content = message.content
    message.topic.destroy
    sleep 1

    visit messages_path(q: "\"#{content}\"")
    page.should_not have_content(content)
  end

  scenario "a message deleted through forum (should fail)" do
    user = sign_in
    message = create :message
    content = message.content
    message.topic.forum.destroy
    sleep 1

    visit messages_path(q: "\"#{content}\"")
    page.should_not have_content(content)
  end
end
