require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
  end
end
