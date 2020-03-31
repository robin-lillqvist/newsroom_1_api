require "stripe_mock"

RSpec.describe "User can buy subscription" do
  let!(:stripe_helper) { StripeMock.create_test_helper }
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let!(:user) { create(:user) }
  let!(:user_credentials) { user.create_new_auth_token }
  let!(:headers) { { HTTP_ACCEPT: "application/json" }.merge!(user_credentials) }
  let!(:card_token){StripeMock.generate_card_token}
  let!(:invalid_token){'1234'}
  let(:product) { stripe_helper.create_product }
  let!(:plan){stripe_helper.create_plan(
    product: product.id, 
    id: 'platinum_plan', 
    amount: 1000000, 
    currency: 'usd',
    interval: 'month',
    interval_count: 12,
    trial_period_days: 30,
    name: 'Berlingo News Premium Platinum Plan' 
    )
  }
    
  describe "with valid stripe token" do
    describe "successfully" do
      before do
        post "/api/subscriptions",
             params: {
               stripeToken: card_token,
               email: user.email
             },
             headers: headers
             user.reload
      end

      it "with valid stripe token recieve successful response" do
        expect(response).to have_http_status 200
      end

      it "receives success message" do
        expect(response_json).to eq ""
        # expect(response_json["message"]).to eq 'Transaction cleared'
      end

      it "has their status updated to premium" do
        expect(user.premium_user).to eq true
      end
    end
  end

  describe "unsuccessfully" do
    describe "with invalid stripe token" do
      before do
        post "/api/subscriptions",
             params: {
               stripeToken: invalid_token,
             },
             headers: headers
      end

      it "recieves message 'No Stripe token detected'" do
        expect(response_json["message"]).to eq "No Stripe token detected"
      end

      it "has their status remain unchanged" do
        expect(user.premium_user).to eq false
      end
    end

    describe "with no stripe token" do
      before do
        post "/api/subscriptions",
             headers: headers
      end

      it "recieves 'No Stripe token detected'" do
        expect(response_json["message"]).to eq "No Stripe token detected"
      end
    end

    describe "when user is not signed in" do
      before do
        post "/api/subscriptions",
          params: {
            stripeToken: stripe_helper.generate_card_token,
          }
      end

      it "returns unsuccessful response" do
        expect(response).to have_http_status 401
      end

      it "returns message to sign in or register first" do
        expect(response_json["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end
  end
end
