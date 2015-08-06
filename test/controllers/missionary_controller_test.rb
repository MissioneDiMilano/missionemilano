require 'test_helper'

class MissionaryControllerTest < ActionController::TestCase
  test "should get orders" do
    get :orders
    assert_response :success
  end

  test "should get orders_new" do
    get :orders_new
    assert_response :success
  end

  test "should get special_questions" do
    get :special_questions
    assert_response :success
  end

  test "should get special_questions_history" do
    get :special_questions_history
    assert_response :success
  end

  test "should get recommendations" do
    get :recommendations
    assert_response :success
  end

  test "should get baptismal_submission" do
    get :baptismal_submission
    assert_response :success
  end

  test "should get parent_contact" do
    get :parent_contact
    assert_response :success
  end

end
