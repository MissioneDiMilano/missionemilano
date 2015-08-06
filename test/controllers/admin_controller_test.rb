require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get special_questions" do
    get :special_questions
    assert_response :success
  end

  test "should get special_questions_area" do
    get :special_questions_area
    assert_response :success
  end

  test "should get special_questions_area" do
    get :special_questions_area
    assert_response :success
  end

  test "should get special_questions_admin" do
    get :special_questions_admin
    assert_response :success
  end

  test "should get orders" do
    get :orders
    assert_response :success
  end

  test "should get orders_fill" do
    get :orders_fill
    assert_response :success
  end

  test "should get orders_fill_view" do
    get :orders_fill_view
    assert_response :success
  end

  test "should get orders_inventory" do
    get :orders_inventory
    assert_response :success
  end

  test "should get orders_inventory_view" do
    get :orders_inventory_view
    assert_response :success
  end

  test "should get parental_contact" do
    get :parental_contact
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

end
