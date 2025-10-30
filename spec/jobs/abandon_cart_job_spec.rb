require 'rails_helper'

RSpec.describe AbandonCartJob, type: :job do
  describe '#perform' do
    let!(:active_recent_cart) { create(:cart, :active_recent) }
    let!(:active_old_cart) { create(:cart, :active_old) }
    let!(:abandoned_recent_cart) { create(:cart, :abandoned) }
    let!(:abandoned_old_cart) { create(:cart, :over_abandoned) }

    subject { AbandonCartJob.new.perform }

    context 'when marking carts as abandoned' do
      it 'marks old active carts as abandoned' do
        expect { subject }
          .to change { active_old_cart.reload.status }
          .from('active')
          .to('abandoned')
      end

      it 'does not mark recent active carts as abandoned' do
        expect { subject }
          .not_to change { active_recent_cart.reload.status }
      end

      it 'sets abandoned_at when marking cart as abandoned' do
        subject
        expect(active_old_cart.reload.abandoned_at).to be_present
      end
    end

    context 'when removing old abandoned carts' do
      it 'removes old abandoned carts' do
        expect { subject }
          .to change { Cart.exists?(abandoned_old_cart.id) }
          .from(true)
          .to(false)
      end

      it 'does not remove recent abandoned carts' do
        expect { subject }
          .not_to change { Cart.exists?(abandoned_recent_cart.id) }
      end

      it 'decreases total cart count by removing old abandoned carts' do
        expect { subject }.to change { Cart.count }.by(-1)
      end
    end
  end
end