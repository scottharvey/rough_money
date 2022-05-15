json.extract! financial_account,
  :id,
  :team_id,
  :name,
  :description,
  :currency,
  :account_type,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_financial_account_url(financial_account, format: :json)
