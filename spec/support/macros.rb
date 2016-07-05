def sign_in_user
  session[:user_id] = Fabricate(:user).id
end

def sign_out_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end