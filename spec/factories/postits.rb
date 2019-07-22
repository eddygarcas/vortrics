FactoryBot.define do
  factory :postit do
    text { "MyString" }
    position { 1 }
    dots { 1 }
    comments { 1 }
    Retrospective { nil }
  end
end
