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

  factory :reset, class: User do
    name { "Reset User" }
    email { "reset@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
    reset_token { User.new_token }
    reset_digest { User.digest(reset_token) }
    reset_sent_at { Time.zone.now }
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
    after(:build) do |lana|
      lana.profile_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'ゲラルト編集.jpeg')), filename: 'ゲラルト編集.jpeg', content_type: 'image/jpeg')
    end
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
