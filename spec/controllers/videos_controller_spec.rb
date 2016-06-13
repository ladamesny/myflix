require 'spec_helper'

describe VideosController do
  describe "GET index" do
    it "sets the @categories variable" do
      action = Category.create(name: "Action")
      comedy = Category.create(name: "Comedy")

      get :index
      assigns(:categories).should == [action]
    end
  end
end
