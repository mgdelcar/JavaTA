json.array!(@comments) do |comment|
  json.extract! comment, :id, :message, :line_number, :source_file_id, :comment_id, :user_id
  json.url comment_url(comment, format: :json)
end
