require 'test_helper'

class MyInfoSiteControllerTest < ActionController::TestCase
  test "should get infopage" do
    get :infopage
    assert_response :success
  end

  test "should get myfavorites" do
    get :myfavorites
    assert_response :success
  end

  test "should get photos" do
    get :photos
    assert_response :success
  end

end
