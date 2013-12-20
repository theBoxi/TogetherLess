json.array!(@logs) do |log|
  json.extract! log, :user_id, :weight, :date
  json.url log_url(log, format: :json)
end
