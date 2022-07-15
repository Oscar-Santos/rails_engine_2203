require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'get all items endpoint' do
      it 'returns all items' do
        create_list(:item, 4)

        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)
        end
    end
  end

  describe 'get one item endpoint' do
    it 'return one item by its id' do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)

      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_a(Hash)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    end

    it 'sad path, cannot get one item' do
      id = create(:item).id

      get "/api/v1/items/99955677"

      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful

      expect(response.status).to eq(404)
      expect(error).to have_key(:message)
    end

    it 'edge case, string id returns 404' do
      id = create(:item).id

      get "/api/v1/items/string"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end
  end

  describe 'Item Create' do
      it 'can create an Item' do
          merchant_id = create(:merchant).id
          item_params = {name: "Rustic Iron Clock",
            description: "Odit quod dicta reprehenderit.",
            unit_price: 772.0,
            merchant_id: merchant_id
            }

          headers = {'CONTENT_TYPE' => "application/json"}

          post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

          created_item = Item.last

          expect(response).to be_successful

          expect(created_item.name).to eq(item_params[:name])
          expect(created_item.description).to eq(item_params[:description])
          expect(created_item.unit_price).to eq(item_params[:unit_price])
      end
  end

      it 'does not create an item if all fields are not input properly or missing' do
          merchant1 = create(:merchant)
          item_params = {name: "Rustic Iron Clock",
            description: "Odit quod dicta reprehenderit.",
            merchant_id: merchant1.id
          }

          headers = {'CONTENT_TYPE' => "application/json"}

          post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

          xxx = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status(400)
          expect(xxx[:message]).to eq('item not created')
      end


    describe 'Item Edit' do
      it 'can edit an Item' do
          merchant = create(:merchant)
          id = create(:item, merchant_id: merchant.id).id

          previous_name = Item.last.name
          item_params = {name: "Rustic Iron Clock"}
          headers = {"CONTENT_TYPE" => "application/json"}

          patch "/api/v1/items/#{id}",
          headers: headers,
          params: JSON.generate({item: item_params})

          item = Item.find_by(id: id)

          expect(response).to be_successful
          expect(item.name).to_not eq(previous_name)
          expect(item.name).to eq("Rustic Iron Clock")
      end

      it 'sad path, bad integer id returns 404' do
          merchant = create(:merchant)
          id = create(:item, merchant_id: merchant.id).id

          previous_name = Item.last.name
          item_params = {name: "Rustic Iron Clock"}
          headers = {"CONTENT_TYPE" => "application/json"}

          patch "/api/v1/items/202020",
          headers: headers,
          params: JSON.generate({item: item_params})

          item = Item.find_by(id: id)

           expect(response).to_not be_successful
           expect(response.status).to eq(404)

           json = JSON.parse(response.body, symbolize_names: true)

           expect(json).to have_key(:message)
      end

      it 'edge case bad merchant id returns 400 or 404)' do

          merchant = create(:merchant)
          id = create(:item, merchant_id: merchant.id).id

          previous_name = Item.last.name
          item_params = {name: "Rustic Iron Clock"}
          headers = {"CONTENT_TYPE" => "application/json"}

          patch "/api/v1/items/#{id}",
          headers: headers,
          params: JSON.generate(merchant_id: '999999999',item: item_params)

          item = Item.find_by(id: id)
          expect(response).to_not be_successful
          expect(response.status).to eq(404)

          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:message)
      end

      it 'edge case, string id returns 404' do
          merchant = create(:merchant)
          id = create(:item, merchant_id: merchant.id).id

          previous_name = Item.last.name
          item_params = {name: "Rustic Iron Clock"}
          headers = {"CONTENT_TYPE" => "application/json"}

          patch "/api/v1/items/string", headers: headers,
                                      params: JSON.generate(merchant_id: merchant.id, item: item_params)

          expect(response).to_not be_successful
          expect(response.status).to eq(404)

          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:message)
      end
    end

    describe 'Item Destroy' do
      it 'can delete an Item' do

          item = create(:item)

          expect(Item.count).to eq(1)

          delete "/api/v1/items/#{item.id}"

          expect(response).to be_successful
          expect(Item.count).to eq(0)
          expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)

      end

      it 'can delete an item and returns not found' do
          item = create(:item)

          expect(Item.count).to eq(1)

          delete "/api/v1/items/NOTFOUND"

          expect(response).to_not be_successful
          expect(Item.count).to eq(1)
      end
    end
end
