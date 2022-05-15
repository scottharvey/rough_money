class Api::V1::FinancialAccountSerializer < Api::V1::ApplicationSerializer
  set_type "financial_account"

  attributes :id,
    :team_id,
    :name,
    :description,
    :currency,
    :account_type,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
