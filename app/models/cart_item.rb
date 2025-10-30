class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, only_integer: true }

  def total_price
    product.unit_price * quantity
  end
end
