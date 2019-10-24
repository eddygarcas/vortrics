
FactoryBot.define do

  factory :user do
    trait :with_team do
      after(:create) do |user|
        create(:team_with_advice, setting_id: user.setting.id)
      end
    end
    email { Faker::Internet.email }
    password { "password"}
    password_confirmation { "password" }
    extuser { "head.hunter" }
    setting
  end


  factory :setting do
    id {Faker::Number.between}
    name {Faker::Name.first_name_men}
    key_file { "rsakey.pem"}
    key_data { Faker::Alphanumeric.alphanumeric.to_s}
    site { "https://jira.test.com"}
    base_path {"/rest/api/2"}
    context {""}
    oauth {true}
    debug {Faker::Boolean.boolean}
    signature_method {"RSA-SHA"}
    consumer_key {"OAuth"}
    login {Faker::Name.name}
    password {Faker::Alphanumeric.alphanumeric.to_s}
  end

end


