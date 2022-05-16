FactoryBot.define do
  factory :financial_account_snapshot do
    team { nil }
    financial_account { nil }
    snapshot { nil }
    total { "" }
    currency { "MyString" }
  end
end
