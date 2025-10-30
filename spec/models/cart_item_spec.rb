require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'when validating' do
    it 'is valid with right attributes' do
      cart_item = build(:cart_item)
      expect(cart_item).to be_valid
    end

    it 'validates quantity is greater than 0' do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:quantity]).to include("must be greater than 0")
    end

    it 'validates quantity is an integer' do
      cart_item = build(:cart_item, quantity: 7.5)
      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:quantity]).to include("must be an integer")
    end

    it 'validates uniqueness of product_id scoped to cart_id' do
      cart = create(:cart)
      product = create(:product)
      
      create(:cart_item, cart: cart, product: product)
      
      duplicate_item = build(:cart_item, cart: cart, product: product)
      expect(duplicate_item).to_not be_valid
      expect(duplicate_item.errors[:product_id]).to include("has already been taken")
    end

    describe 'associations' do
      it { should belong_to(:product) }
      it { should belong_to(:cart) }
    end 
  end
end
