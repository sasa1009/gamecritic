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

  factory :review_with_image, class: Review do
    score { 9 }
    title { "適正なレビュー" }
    review { "これは適正なレビューです" }
    after(:build) do |review_with_image|
      review_with_image.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'キングダムハーツプレイ１.jpg')), filename: 'キングダムハーツプレイ１.jpg', content_type: 'image/jpeg')
    end
  end
end
