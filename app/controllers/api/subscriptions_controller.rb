class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  rescue_from Stripe::InvalidRequestError, with: :invalid_token_id

  def create
    customer = Stripe::Customer.list(email: params[:email]).data.first
    customer = Stripe::Customer.create({ email: params[:email], source: params[:stripeToken] }) unless customer
    subscription = Stripe::Subscription.create({ customer: customer.id, plan: "basic_subscription" })
    status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid

    if (subscription.paid)
      current_user.premium_user = true
      current_user.save
      render json: { message: "stripe.pay_success" }
    end

    if (subscription.unpaid)
      current_user.premium_user = false
      current_user.save
      render json: { message: "stripe.missing_token" }
    end
  end

  private

  def invalid_token_id
    render json: { message: "No Stripe token detected" }
  end
end
