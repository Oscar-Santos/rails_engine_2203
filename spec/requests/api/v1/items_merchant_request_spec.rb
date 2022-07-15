require 'rails_helper'

 RSpec.describe 'Item Request' do
   describe 'HappyPath' do
     describe 'getting an Items Merchant' do
       it 'can get the merchant data for a given Item ID' do

         merchant_1 = create(:merchant)
         merchant_2 = create(:merchant)
         item = create(:item, merchant_id: merchant_1.id)

         get "/api/v1/items/#{item.id}/merchant"

         merchant = JSON.parse(response.body, symbolize_names: true)
         expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
         expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
         expect(item.merchant_id).to eq(merchant[:data][:id].to_i)
       end
     end
   end

     describe 'Sad Path' do
       it 'sad path' do
         merchant_1 = create(:merchant)
         merchant_2 = create(:merchant)
         item = create(:item, merchant_id: merchant_1.id)

         get "/api/v1/items/999999999/merchant"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        end
     end

     describe 'Edge Case' do
       it 'edge case' do
         merchant_1 = create(:merchant)
         merchant_2 = create(:merchant)
         item = create(:item, merchant_id: merchant_1.id)

         get "/api/v1/items/string/merchant"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        end
     end
   end
