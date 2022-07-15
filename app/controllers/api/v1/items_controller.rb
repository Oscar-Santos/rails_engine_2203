class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)

    if item.save
      render(json: ItemSerializer.new(item), status: 201)
    else
      render json: { :message => 'item not created'}, status: 400
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id]) if params[:merchant_id].present?
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    render json: Item.destroy(params[:id])
    #change to work with invoices
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
