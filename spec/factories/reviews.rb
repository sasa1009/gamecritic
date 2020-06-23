FactoryBot.define do
  factory :review, class: Review do
    score { 5 }
    title { "適正なレビュー" }
    review { "これは適正なレビューです" }
  end

  factory :valid_review, class: Review do
    score { 9 }
    title { "適正なレビュー" }
    review { "これは適正なレビューです" }
  end

  factory :invalid_review, class: Review do
    score { }
    title { }
    review { }
  end
end
