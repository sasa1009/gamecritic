FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :admin, class: User do
    name { "Admin User" }
    email { "admin@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end

  factory :archer, class: User do
    name { "Sterling Archer" }
    email { "archer@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :michael, class: User do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.gov" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :malory, class: User do
    name { "Malory Archer" }
    email { "boss@example.gov" }
    password { "password" }
    password_confirmation { "password" }
  end
end
