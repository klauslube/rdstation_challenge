class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :product_id, uniqueness: { scope: :cart_id }

  after_save :update_cart_total
  after_destroy :update_cart_total

  def total_price
    product.price * quantity
  end

  private

  def update_cart_total
    cart.calculate_total_price!
  end
end
