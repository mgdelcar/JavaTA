require 'test_helper'

class EvaluatorControllerTest < ActionController::TestCase
  test "should get compile" do
    get :compile
    assert_response :success
  end

end
