FactoryBot.define do
  factory :article do
    title {'This is an article'} 
    lead {'This is an article lead'}
    content {'This is article content'}
    category {'latest_news'}
    premium { true }
  end
end
