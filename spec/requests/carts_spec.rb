require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let(:cart) { Cart.create }
  let(:product) { Product.create(name: "Test Product", price: 10.0) }

  
  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return({ cart_id: cart.id })
  end

  describe "POST /add_items" do
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end

  describe "POST /cart" do 
    let(:params) {{ product_id: product.id, quantity: 2 }}

    subject { post '/cart', params: params, as: :json }

    context "when the cart item is not in the cart" do
      it "creates a new cart item" do 
        expect { subject }.to change { CartItem.count }.by(1)
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        item = json["products"].first
        expect(item["id"]).to eq(product.id)
        expect(item["quantity"]).to eq(2)
        expect(item["total_price"]).to eq(20.0)
      end
    end
  end 

  describe "GET /cart" do
    subject { get '/cart', as: :json }
    
    context 'when the cart is empty' do
      before { cart.cart_items.destroy_all }
      it "returns the current cart with 0 cart items" do
        subject
        json = JSON.parse(response.body)
        expect(json["products"]).to eq([])
      end
    end

    context 'when the cart has items' do
      let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

      it "returns the current cart with products" do
        subject
        json = JSON.parse(response.body)
        expect(json["products"]).not_to be_empty
        expect(json["products"].first["name"]).to eq(product.name)
      end
    end
  end

  describe "DELETE /cart/:product_id" do
    let!(:product) { Product.create!(name: "Test Product", price: 10.0) }
    
    context "when the cart does not exist" do
      before do
        cart.destroy 
        allow_any_instance_of(ApplicationController)
          .to receive(:session)
          .and_return({ cart_id: 0 })
      end

      it "returns a 404 error" do
        delete "/cart/#{product.id}", as: :json
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Cart not found")
      end
    end

    context "when the product is not in the cart" do
      it "returns a 404 error" do
        delete "/cart/#{product.id}", as: :json
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json["error"]).to eq("Product not found in cart")
      end
    end
  end
end
