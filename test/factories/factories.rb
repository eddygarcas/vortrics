
FactoryBot.define do

  factory :user do
    trait :with_team do
      after(:create) do |user|
        create(:team_with_advice, setting_id: user.setting.id)
      end
    end
    trait :with_sprint do
      after(:create) do |user|
        create(:team_with_sprint, setting_id: user.setting.id)
      end
    end
    id {Faker::Number.between(from: 1,to: 50000)}
    email { Faker::Internet.email }
    password { "password"}
    password_confirmation { "password" }
    extuser { "eduard.garcia" }
    setting
  end

  factory :setting do
    id {Faker::Number.between(from: 1,to: 50000)}
    name {Faker::Name.first_name_men}
    key_file { "rsakey.pem"}
    key_data { Faker::Alphanumeric.alphanumeric.to_s}
    site { "http://jira.test.com"}
    base_path {"/rest/api/2"}
    context {""}
    oauth {true}
    debug {Faker::Boolean.boolean}
    signature_method {""}
    consumer_key {"OAuth"}
    login { "eduard.garcia"}
    password {"test"}
  end

end


