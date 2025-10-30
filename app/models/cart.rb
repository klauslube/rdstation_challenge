class Cart < ApplicationRecord
  enum status: { active: 0, abandoned: 1 }

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :total_price, numericality: { greater_than_or_equal_to: 0 } 

  def update_last_interaction!
    update!(last_interaction_at: Time.current)
  end
  
  def calculate_total_price!
    update!(total_price: cart_items.sum(&:total_price))
  end
end
