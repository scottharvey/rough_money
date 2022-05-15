FactoryBot.define do
  factory :financial_account do
    association :team
    name { "MyString" }
    description { "MyString" }
    currency { "MyString" }
    account_type { 1 }
  end
end
