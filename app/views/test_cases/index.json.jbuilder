json.array!(@test_cases) do |test_case|
  json.extract! test_case, :id, :input, :output, :points, :max_time_execution_sec, :problem_id
  json.url test_case_url(test_case, format: :json)
end
