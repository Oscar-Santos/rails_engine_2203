class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all

    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])

    render json: MerchantSerializer.new(merchant)
  end

  def most_items
    merchants = Merchant.top_merchants_by_items_sold(params[:quantity])
    render json: MerchantItemCountSerializer.new(merchants)
  end
end
