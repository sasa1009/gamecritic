FactoryBot.define do
  factory :game do
    user_id { 1 }
    title { "MyString" }
    developer { "MyString" }
    release_date { "2020-05-02 12:50:16" }
    summary { "MyText" }
  end
end
