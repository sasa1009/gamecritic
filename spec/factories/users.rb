FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "Example@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
