class Api::V1::MerchantsSearchController < ApplicationController

  def find
    if params[:name].present?
    merchant = Merchant.search_merchant(params[:name])
      if merchant
        render json: MerchantSerializer.new(merchant)
      elsif merchant.nil?
        render json: { data: { message: 'Error: Merchant Not Found' } }
      end
    elsif params[:name].nil? || params[:name].empty?
      render status: 400
    end
  end

end
