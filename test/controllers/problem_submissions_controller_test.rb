require 'test_helper'

class ProblemSubmissionsControllerTest < ActionController::TestCase
  setup do
    @problem_submission = problem_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:problem_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create problem_submission" do
    assert_difference('ProblemSubmission.count') do
      post :create, problem_submission: { file_relative_path: @problem_submission.file_relative_path, iteration: @problem_submission.iteration, problem_id: @problem_submission.problem_id, when: @problem_submission.when }
    end

    assert_redirected_to problem_submission_path(assigns(:problem_submission))
  end

  test "should show problem_submission" do
    get :show, id: @problem_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @problem_submission
    assert_response :success
  end

  test "should update problem_submission" do
    patch :update, id: @problem_submission, problem_submission: { file_relative_path: @problem_submission.file_relative_path, iteration: @problem_submission.iteration, problem_id: @problem_submission.problem_id, when: @problem_submission.when }
    assert_redirected_to problem_submission_path(assigns(:problem_submission))
  end

  test "should destroy problem_submission" do
    assert_difference('ProblemSubmission.count', -1) do
      delete :destroy, id: @problem_submission
    end

    assert_redirected_to problem_submissions_path
  end
end
