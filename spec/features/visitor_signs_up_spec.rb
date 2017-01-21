require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password' do
    sign_up_with name: 'Test1',
      email: 'valid@example.com',
      password: 'password',
      password_confirmation: 'password'
    page.should have_content('Test1')
  end

  scenario 'and then signs out' do
    sign_in
    page.find(:xpath, "//a[@href='#{destroy_user_session_path}']").click
    page.should have_content('Register')
  end

  scenario 'with invalid email (should fail)' do
    sign_up_with name: 'Test2',
      email: 'invalid',
      password: 'password',
      password_confirmation: 'password'
    page.should have_content('Please review the problems below')
  end

  scenario 'with blank password (should fail)' do
    sign_up_with name: 'Test3',
      email: 'valid@example.com',
      password: '',
      password_confirmation: ''
    page.should have_content('Please review the problems below')
  end 

  scenario 'with invalid password confirmation (should fail)' do
    sign_up_with name: 'Test4',
      email: 'valid@example.com',
      password: 'password',
      password_confirmation: 'wordpass'
    page.should have_content('Please review the problems below')
  end 
end
