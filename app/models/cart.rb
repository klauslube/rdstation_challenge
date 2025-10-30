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
  
  def mark_as_abandoned
    return false unless active? && last_interaction_at && last_interaction_at <= 3.hours.ago

    update!(status: :abandoned, abandoned_at: last_interaction_at + 3.hours)
  end

  def remove_if_abandoned
    return false unless abandoned? && abandoned_at

    return false unless abandoned_at.to_date <= 7.days.ago.to_date

    destroy
  end
end
