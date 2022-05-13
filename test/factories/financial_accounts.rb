FactoryBot.define do
  factory :financial_account do
    team { nil }
    name { "MyString" }
    description { "MyString" }
    currency { "MyString" }
    account_type { 1 }
  end
end
