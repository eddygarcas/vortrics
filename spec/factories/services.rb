FactoryBot.define do
  factory :service do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
    access_token { "MyString" }
    access_token_secret { "MyString" }
    refresh_token { "MyString" }
    expires_at { "2019-11-20 09:27:58" }
    auth { "MyText" }
  end
end
