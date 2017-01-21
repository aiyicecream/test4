require 'spec_helper'

feature 'User creates' do
  [:user, :admin].each do |role|
    scenario "a topic as #{role}" do
      forum = create :forum
      user = sign_in(role)

      visit forum_path(forum)
      page.all(:xpath, "//a[@href='#{new_topic_path(forum_id: forum.id)}']").first.click
      fill_in 'Title', with: 'Hello'
      # Use wmd-input instead of Message to avoid confusion with messages ACLs fields
      fill_in 'wmd-input', with: 'Check me'
      find('.btn-primary').click
      page.should have_content('Hello')
      page.should have_content(user.name)
      page.should have_content('Check me')
    end

    scenario "a message as #{role}" do
      topic = create :topic
      user = sign_in(role)

      visit topic_path(topic)
      fill_in 'Message', with: 'Check me'
      find('.btn-primary').click
      page.should have_content(user.name)
      page.should have_content('Check me')
    end

    scenario "a small message as #{role}" do
      topic = create :topic
      user = sign_in(role)

      visit topic_path(topic)
      fill_in 'small_message_content', with: 'Hi!'
      find('.messages input[type=submit].hidden').click
      page.should have_content(user.name)
      page.should have_content('Hi!')
    end
  end

  scenario "a forum as user (should fail)" do
    user = sign_in
    visit forums_path
    page.should_not have_xpath "//a[@href='#{new_forum_path}']"
    visit new_forum_path
    page.should_not have_xpath "//form[@action='#{forums_path}']"
  end

  scenario "a forum as admin" do
    user = sign_in(:admin)
    visit forums_path
    page.all(:xpath, "//a[@href='#{new_forum_path}']").first.click
    fill_in 'Title', with: 'My forum'
    find('.btn-warning').click
    page.should have_content('My forum')
  end

  scenario "a group" do
    user = sign_in
    visit groups_path
    page.all(:xpath, "//a[@href='#{new_group_path}']").first.click
    fill_in 'Name', with: 'My friends'
    select 'Private', from: 'Status'
    find('.btn-primary').click
    page.should have_content('My friends')
  end
end
