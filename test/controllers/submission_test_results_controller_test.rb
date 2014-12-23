require 'test_helper'

class SubmissionTestResultsControllerTest < ActionController::TestCase
  setup do
    @submission_test_result = submission_test_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:submission_test_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create submission_test_result" do
    assert_difference('SubmissionTestResult.count') do
      post :create, submission_test_result: { errors_output: @submission_test_result.errors_output, execution_time_in_ms: @submission_test_result.execution_time_in_ms, feedback: @submission_test_result.feedback, output: @submission_test_result.output, return_state: @submission_test_result.return_state, terminates?: @submission_test_result.terminates?, test_case_id: @submission_test_result.test_case_id }
    end

    assert_redirected_to submission_test_result_path(assigns(:submission_test_result))
  end

  test "should show submission_test_result" do
    get :show, id: @submission_test_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @submission_test_result
    assert_response :success
  end

  test "should update submission_test_result" do
    patch :update, id: @submission_test_result, submission_test_result: { errors_output: @submission_test_result.errors_output, execution_time_in_ms: @submission_test_result.execution_time_in_ms, feedback: @submission_test_result.feedback, output: @submission_test_result.output, return_state: @submission_test_result.return_state, terminates?: @submission_test_result.terminates?, test_case_id: @submission_test_result.test_case_id }
    assert_redirected_to submission_test_result_path(assigns(:submission_test_result))
  end

  test "should destroy submission_test_result" do
    assert_difference('SubmissionTestResult.count', -1) do
      delete :destroy, id: @submission_test_result
    end

    assert_redirected_to submission_test_results_path
  end
end
