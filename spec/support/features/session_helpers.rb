module Features
  module SessionHelpers
    def sign_up_with(user)
      visit new_user_registration_path
      fill_in 'user_name', with: user[:name]
      fill_in 'user_email', with: user[:email]
      fill_in 'user_password', with: user[:password]
      fill_in 'user_password_confirmation', with: user[:password_confirmation]
      click_button 'Sign up'
    end

    def sign_in(role = :user)
      user = create(role)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      user
    end
  end
end
