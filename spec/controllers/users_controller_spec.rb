require 'spec_helper.rb'

RSpec.describe UsersController, type: :controller  do
  context "GET #index"  do
    it "should return success response" do
      get :index
      expect(response).to be_success
    end
  end

  context "create action"  do
    it "render status is created if validations passed" do
      post :create, item: {name:"user1", email:"user1@gmail.com"}
      response.status.should == :created
    end

    it "render status is unprocessable_entity if validations failed" do
      post :create, item: {name:"user1", email: nil}
      response.status.should == :unprocessable_entity
    end
  end

  context "GET #show"  do
    it "should return success response" do
      user = User.create!(name: "user1", email:"user1@gmail.com", password:"123456", password_confirmation:"123456")
      get :show, params: {id: user.to_param}
      expect(response).to be_success
    end

    it "should render show template if user is found" do
      user = User.create!(name: "user2", email:"user2@gmail.com", password:"123456", password_confirmation:"123456")
      get :show, params: {id: user.id}
      response.should render_template('show')
    end

    it "should render 404 page if user is not found" do
      get :show, params: {id: 0}
      response.status.should == 404
    end
  end
end
