def sign_in_user
  session[:user_id] = Fabricate(:user).id
end

def sign_out_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email[]", with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end