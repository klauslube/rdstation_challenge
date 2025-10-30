class CartsController < ApplicationController
  before_action :set_session_cart, only: [:show]

  def show 
    render json: cart_json_response(@cart || Cart.new)
  end

  private

  def set_session_cart
    @cart = Cart.find_by(id: session[:cart_id])
  end

  def cart_json_response(cart)
    {
      id: cart.id,
      products: cart.cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price.to_f,
          total_price: item.total_pricec.to_f
        }
      end,
      total_price: cart.total_price.to_f
    }
  end
end
