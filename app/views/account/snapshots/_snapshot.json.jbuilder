json.extract! snapshot,
  :id,
  :team_id,
  :note,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_snapshot_url(snapshot, format: :json)
