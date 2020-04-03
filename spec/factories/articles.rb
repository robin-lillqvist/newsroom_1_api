FactoryBot.define do
  factory :article do
    title {'This is an article'} 
    lead {'This is an article lead'}
    content {'This is article content'}
    category {'latest_news'}
    premium { true }
    trait :with_image do
      image { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'), 'image/png') }
    end
  end
end
