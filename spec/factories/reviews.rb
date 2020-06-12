FactoryBot.define do
  factory :review do
    user_id { 1 }
    game_id { 1 }
    score { 1 }
    title { "MyText" }
    review { "MyText" }
  end
end
