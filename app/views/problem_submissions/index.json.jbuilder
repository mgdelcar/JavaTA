json.array!(@problem_submissions) do |problem_submission|
  json.extract! problem_submission, :id, :file_relative_path, :iteration, :when, :problem_id
  json.url problem_submission_url(problem_submission, format: :json)
end
