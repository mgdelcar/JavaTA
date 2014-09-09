json.array!(@problems) do |problem|
  json.extract! problem, :id, :title, :description, :detect_plagiarism, :language
  json.url problem_url(problem, format: :json)
end
