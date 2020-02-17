FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "Example@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    remember_digest { nil }
  end
end
