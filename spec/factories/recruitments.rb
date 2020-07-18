FactoryBot.define do
  factory :recruitment do
    title { "適正なフレンド募集" }
    sequence(:description) { |n| "#{n}ホゲホゲホゲ"}
    game_id {}
    association :user
  end
  
  factory :valid_recruitment, class: Recruitment do
    title { "適正なフレンド募集" }
    sequence(:description) { |n| "#{n}ホゲホゲホゲ" }
    game_id {}
    user_id {}
  end
end
