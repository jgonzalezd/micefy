require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get landing" do
    get :landing
    assert_response :success
  end

  test "should get faq" do
    get :faq
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get features" do
    get :features
    assert_response :success
  end

end
