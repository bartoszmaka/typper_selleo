module Features
  module SessionHelper
    def log_in(email, password)
      user = create(:user, email: email, password: password)

      visit new_user_registration_path

      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_button 'Sign up'

      user
    end
  end
end

