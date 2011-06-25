require 'test_helper'

class WinnersControllerTest < ActionController::TestCase
  setup do
    @winner = winners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:winners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create winner" do
    assert_difference('Winner.count') do
      post :create, :winner => @winner.attributes
    end

    assert_redirected_to winner_path(assigns(:winner))
  end

  test "should show winner" do
    get :show, :id => @winner.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @winner.to_param
    assert_response :success
  end

  test "should update winner" do
    put :update, :id => @winner.to_param, :winner => @winner.attributes
    assert_redirected_to winner_path(assigns(:winner))
  end

  test "should destroy winner" do
    assert_difference('Winner.count', -1) do
      delete :destroy, :id => @winner.to_param
    end

    assert_redirected_to winners_path
  end
end
