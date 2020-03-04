FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :admin, class: User do
    name { "Admin User" }
    email { "admin@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :archer, class: User do
    name { "Sterling Archer" }
    email { "archer@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :michael, class: User do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { false }
    activated_at { nil }
  end

  factory :lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :malory, class: User do
    name { "Malory Archer" }
    email { "boss@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
end
