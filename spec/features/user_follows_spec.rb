require 'spec_helper'

feature 'User follows' do
  scenario "by clicking a follow link" do
    user = sign_in
    forum = create :forum
    visit forum_path(forum)
    page.should have_content 'follow'
    Capybara.current_session.driver.post follows_path(follow: {followable_id: forum.id, followable_type: forum.class})
    visit forum_path(forum)
    page.should have_content 'unfollow'
  end

  scenario "a user" do
    user = sign_in
    other = create :user
    Capybara.current_session.driver.post follows_path(follow: {followable_id: other.id, followable_type: other.class})
    topic = create :topic, user: other
    visit notifications_path
    page.should have_content topic.first_message.content
    visit follows_path
    page.should have_content other.name.split.first
  end

  scenario "a forum" do
    user = sign_in
    forum = create :forum
    Capybara.current_session.driver.post follows_path(follow: {followable_id: forum.id, followable_type: forum.class})
    topic = create :topic, forum: forum
    visit notifications_path
    page.should have_content topic.first_message.content
  end

  scenario "a topic" do
    user = sign_in
    topic = create :topic
    Capybara.current_session.driver.post follows_path(follow: {followable_id: topic.id, followable_type: topic.class})
    message = create :message, topic: topic
    visit notifications_path
    page.should have_content message.content
    visit follows_path
    page.should have_content topic.name
  end
end
