RSpec.describe 'POST /articles', type: :request do
  let(:journalist) { create(:user, role: 'journalist') }
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let(:journalist_headers) do
    { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials)
  end
  let(:user) { create(:user, role: 'user') }
  let(:user_credentials) { user.create_new_auth_token }
  let(:user_headers) do
    { HTTP_ACCEPT: "application/json" }.merge!(user_credentials)
  end

  let(:image) do
    {
      type: 'application/jpg',
      encoder: 'name=new_iphone.jpg:base64',
      data: 'KFKJSDHFWE78723JEWKH247YDAHSD&JSDFJKDJKSHFJGDSKJHKFGS/JSDFGJSH34BHGJH3',
      extension: 'jpg'
    }
  end

  describe 'with valid params' do
    before do
      post '/api/articles',
        params: {
          article: {
            title: 'New Car',
            lead: "It's a Berlingo",
            content: 'Oliver hates it',
            category: 'latest_news',
            image: image,
            premium: "true"
          },
        },
        headers: journalist_headers
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end

    it 'returns a success message' do
      expect(response_json['message']).to eq 'Your article was successfully created'
    end

    it 'article has image attached to it' do
      article = Article.where(title: response.request.params['article']['title'])
      expect(article.first.image.attached?).to eq true
    end
  end

  describe 'users cannot create articles' do
    before do
      post '/api/articles',
        params: {
          article: {
            title: 'New Car',
            lead: "It's a Berlingo",
            content: 'Oliver hates it',
            category: 'latest_news',
            image: image,
            premium: "true"
          },
        },
        headers: user_headers
    end

    it 'returns 401 status' do
      expect(response.status).to eq 401
    end

    it 'returns an error message' do
      expect(response_json['error']).to eq 'You must be a journalist to create an article'
    end
  end

  describe 'with valid params' do
    before do
      post '/api/articles',
        params: {
          article: {
            title: '', 
            lead: '',
            content: '',
            category: 'latest_news',
            image: ''
          }
        },
        headers: journalist_headers
    end

    it 'returns 422 response' do
      expect(response.status).to eq 422
    end

    it 'returns an unsuccessful message' do
      expect(response_json['error']).to eq 'Something went wrong'
    end
  end
end
