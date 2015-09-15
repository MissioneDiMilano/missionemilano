require 'test_helper'

class AjaxControllerTest < ActionController::TestCase
  test "should get orders" do
    get :orders
    assert_response :success
  end

  test "should get special_questions" do
    get :special_questions
    assert_response :success
  end

  test "should get inventory" do
    get :inventory
    assert_response :success
  end

  test "should get parent_contacts" do
    get :parent_contacts
    assert_response :success
  end

  test "should get baptismal_submissions" do
    get :baptismal_submissions
    assert_response :success
  end

end
