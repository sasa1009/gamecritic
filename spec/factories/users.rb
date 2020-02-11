FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "Example@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

  factory :michael, class: User do
    name { "Michael Example" }
    email { "michael@gmail.com" }
    password { User.digest("password") }
  end
end
