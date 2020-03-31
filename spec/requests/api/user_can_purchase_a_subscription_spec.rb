require "stripe_mock"

RSpec.describe "POST api/subscriptions" do
  let!(:stripe_helper) { StripeMock.create_test_helper }
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }

  let(:card_token) { stripe_helper.generate_card_token }
  let(:invalid_token) { "123456789" }

  let(:product) { stripe_helper.create_product }
  let!(:plan) {
    stripe_helper.create_plan(
      id: "platinum_plan",
      amount: 1000000,
      currency: "usd",
      interval: "month",
      interval_count: 12,
      name: "Berlingo News Premium Platinum Plan",
      product: product.id,
    )
  }

  let(:user) { create(:user) }
  let(:user_credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: "application/json" }.merge!(user_credentials) }

  describe "with valid stripe token" do
    describe "successfully" do
      before do
        post "/api/subscriptions",
             params: {
               stripeToken: card_token,
               email: user.email,
             },
             headers: headers
        user.reload
      end

      it "with valid stripe token recieve successful response" do
        expect(response).to have_http_status 200
      end

      it "receives success message" do
        expect(response_json["message"]).to eq "Transaction cleared"
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
               email: user.email,
             },
             headers: headers
      end

      it "recieves message 'Transaction rejected, token invalid'" do
        expect(response_json["error_message"]).to eq "Invalid token id: 123456789"
      end

      it "recieve error response" do
        expect(response).to have_http_status 400
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
        expect(response_json["error_message"]).to eq "No stripe token sent"
      end

      it "recieve error response" do
        expect(response).to have_http_status 400
      end
    end

    describe "when user is not signed in" do
      before do
        post "/api/subscriptions",
          params: {
            stripeToken: card_token,
          }
      end

      it "returns unsuccessful response" do
        expect(response).to have_http_status 401
      end

      it "returns message to sign in or register first" do
        expect(response_json["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    describe "when stripe declines subscription for user" do
      before do
        custom_error = StandardError.new("Subscription cannot be created")

        StripeMock.prepare_error(custom_error, :create_subscription)

        post "/api/subscriptions",
          params: {
            stripeToken: card_token,
            email: user.email,
          },
          headers: headers
      end

      it "returns unsuccessful response" do
        expect(response).to have_http_status 400
      end

      it "returns error message" do
        expect(response_json["error_message"]).to eq "Subscription cannot be created"
      end
    end
  end
end
