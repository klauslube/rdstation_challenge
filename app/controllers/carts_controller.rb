class CartsController < ApplicationController
  before_action :set_session_cart, only: [:show]
  before_action :find_or_create_cart, only: %i[create add_items]
  before_action :set_product, only: %i[create add_items destroy]

  def show 
    render json: cart_json_response(@cart || Cart.new)
  end

  def create
    cart_item = @cart.cart_items.find_or_initialize_by(product: @product)
    cart_item.quantity = params[:quantity]
    cart_item.save!

    @cart.update_last_interaction!

    render json: cart_json_response(@cart), status: :created
  end

  def add_items
    cart_item = @cart.cart_items.find_or_initialize_by(product: @product)
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    cart_item.save!

    @cart.update_last_interaction!

    render json: cart_json_response(@cart)
  end

  def destroy
    @cart = Cart.find_by(id: session[:cart_id])
    return render json: { error: 'Cart not found' }, status: :not_found unless @cart

    cart_item = @cart.cart_items.find_by(product: @product)
    return render json: { error: 'Product not found in cart' }, status: :not_found unless cart_item
    
    cart_item.destroy!
    @cart.update_last_interaction!
    
    render json: cart_json_response(@cart)
  end

  private

  def set_session_cart
    @cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def find_or_create_cart
    @cart = set_session_cart
    
    unless @cart
      @cart = Cart.create!(last_interaction_at: Time.current)
      session[:cart_id] = @cart.id
    end
  
    @cart
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
          total_price: item.total_price.to_f
        }
      end,
      total_price: cart.total_price.to_f
    }
  end
end
