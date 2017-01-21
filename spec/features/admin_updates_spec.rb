require 'spec_helper'

feature 'Admin updates' do
  scenario "a forum" do
    user = sign_in :admin
    forum = create :forum

    visit forum_path(forum)
    page.find(:xpath, "//a[@href='#{edit_forum_path(forum)}']").click
    fill_in 'Title', with: 'Forum updated'
    find('.btn-warning').click
    page.should have_content('Forum updated')
  end

  scenario "somebody else topic" do
    user = sign_in :admin
    topic = create :topic

    visit topic_path(topic)
    page.find(:xpath, "//a[@href='#{edit_topic_path(topic)}']").click
    fill_in 'Title', with: 'Topic updated'
    find('.btn-warning').click
    page.should have_content('Topic updated')
  end

  scenario "somebody else message" do
    user = sign_in :admin
    message = create :message

    visit topic_path(message.topic)
    page.find(:xpath, "//a[@href='#{edit_message_path(message)}']").click
    fill_in 'Message', with: 'Message updated'
    find('.btn-warning').click
    page.should have_content('Message updated')
  end
end
