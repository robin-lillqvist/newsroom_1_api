# frozen_string_literal: true

RSpec.describe Api::ArticlesController, type: :request do
  describe 'GET /article/1 successfully' do
    let!(:article) { create(:article, :with_image, title: 'Article Title', lead: 'At some point there will be something the read in the lead', content: 'Article content will go here for the user to read.', premium: true) }

     before do  
       get "/api/articles/#{Article.last.id}"
     end

    it 'should return a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'should return title articles' do
      expect(response_json['article']['title']).to eq 'Article Title'
    end

    it 'should return lead articles' do
      expect(response_json['article']['lead']).to eq 'At some point there will be something the read in the lead'
    end

    it 'should return content articles' do
      expect(response_json['article']['content']).to eq 'Article content will go here for the user to read.'
    end

    it 'should return article category' do
      expect(response_json['article']['category']).to eq 'latest_news'
    end

    it 'should return article premium' do
      expect(response_json['article']['premium']).to eq true
    end
  end
end
