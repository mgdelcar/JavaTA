json.array!(@submission_test_results) do |submission_test_result|
  json.extract! submission_test_result, :id, :execution_time_in_ms, :output, :errors_output, :feedback, :terminates?, :return_state, :execution_result, :test_case_id, :problem_id
  json.url submission_test_result_url(submission_test_result, format: :json)
end
