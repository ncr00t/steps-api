require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should redirect index when no logged in" do
    get :index
    assert_redirected_to auth_login_url
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to auth_login_url
  end

end
