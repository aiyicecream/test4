require 'spec_helper'

feature 'User updates profile' do
  scenario "its location" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Location', with: 'Location updated'
    click_on 'Update'
    visit user_path(user)
    page.should have_content('Location updated')
  end

  scenario "its password" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Name', with: 'Name updated'
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'password2'
    fill_in 'user_password_confirmation', with: 'password2'
    click_on 'Update'
    page.should_not have_content('review the problems below')
  end

  scenario "its password without confirmation (should fail)" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Name', with: 'Name updated'
    fill_in 'user_current_password', with: 'password'
    fill_in 'user_password', with: 'password2'
    click_on 'Update'
    page.should have_content('review the problems below')
  end

  scenario "its password without current password (should fail)" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Name', with: 'Name updated'
    fill_in 'user_password', with: 'password2'
    fill_in 'user_password_confirmation', with: 'password2'
    click_on 'Update'
    page.should have_content('review the problems below')
  end

  scenario "its name with current password" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Name', with: 'Name updated'
    fill_in 'user_current_password', with: 'password'
    click_on 'Update'
    visit user_path(user)
    page.should have_content('Name updated')
  end

  scenario "its email with current password" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Email', with: 'email@updated.com'
    fill_in 'user_current_password', with: 'password'
    click_on 'Update'
    page.should_not have_content('review the problems below')
  end

  scenario "its name without current password (should fail)" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Name', with: 'Name updated'
    click_on 'Update'
    visit user_path(user)
    page.should_not have_content('Name updated')
  end

  scenario "its email without current password (should fail)" do
    user = sign_in
    topic = create :topic, user: user

    visit edit_user_registration_path
    fill_in 'Email', with: 'email@updated.com'
    click_on 'Update'
    page.should have_content('review the problems below')
  end
end
