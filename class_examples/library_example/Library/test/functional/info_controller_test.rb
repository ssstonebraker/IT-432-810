require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should get policies" do
    get :policies
    assert_response :success
  end

  test "should get staff" do
    get :staff
    assert_response :success
  end

end
