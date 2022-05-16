FactoryBot.define do
  factory :snapshot do
    association :team
    note { "MyString" }
    total { "" }
  end
end
