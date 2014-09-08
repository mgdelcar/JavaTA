json.array!(@problems) do |problem|
  json.extract! problem, :id, :title, :discription, :detectPlagiarism, :language
  json.url problem_url(problem, format: :json)
end
