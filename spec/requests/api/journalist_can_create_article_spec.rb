RSpec.describe 'POST /articles', type: :request do
let(:headers) { { HTTP_ACCEPT:'application/json' } }

  describe 'with valid params' do
    before do
      post '/api/articles',
      params: {
        article: {
          title:"New Car",
          lead: "It's a Berlingo",
          content: "Oliver hates it",
          category: "latest_news"
        }
      },
      headers: headers
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end

    it 'returns a success message' do
      expect(response_json['message']).to eq 'Your article was successfully created'
    end
  end
end