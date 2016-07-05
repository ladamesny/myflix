shared_examples "require sign in" do
  it "redirects to the sign in page" do
    sign_out_user
    action
    expect(response).to redirect_to sign_in_path
  end
end