RSpec.describe Api::ArticlesController, type: :request do 
  let!(:articles) { 3.times { create(:article) } } 
  
  describe 'GET /article' do
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
end 