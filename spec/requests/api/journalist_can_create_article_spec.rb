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

  describe 'with valid params' do
    before do
      post '/api/articles',
      params: {
        article: {
          title:"",
          lead: "",
          content: "",
          category: "latest_news"
        }
      },
      headers: headers
    end

    it 'returns 422 response' do
      expect(response.status).to eq 422
    end

    it 'returns an unsuccessful message' do
      expect(response_json['error']).to eq 'Something went wrong'
    end
  end
end