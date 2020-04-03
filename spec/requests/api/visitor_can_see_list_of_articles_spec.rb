RSpec.describe Api::ArticlesController, type: :request do
  describe 'GET /article successfully' do
    let!(:articles) { 3.times { create(:article, :with_image) } }
    before do
      get '/api/articles'
    end

    it 'should return a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'should return three articles' do
      expect(response_json['articles'].count).to eq 3
    end
  end

  describe 'GET /article unsuccessfully' do
    before do
      get '/api/articles'
    end

    it 'should return a 422 response' do
      expect(response).to have_http_status 422
    end

    it 'should return error message' do
      expect(response_json['error']).to include 'No articles found'
    end
  end
end
