class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.search_merchant(name)
    where("name ILIKE ?", "%#{name}%").first
  end

  def self.top_merchants_by_revenue(quantity)
    Merchant
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .group(:id)
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .order(revenue: :desc)
    .limit(quantity)
  end

  def self.top_merchants_by_items_sold(quantity)
    #Merchant.joins(invoices: :invoice_items).select("merchants.*, sum(invoice_items.quantity) as count").group(:id).order(count: :desc).limit(quantity)
    select("merchants.*, sum(invoice_items.quantity) as total")
    .joins(invoices: [:invoice_items, :transactions])
    .group(:id)
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .order(total: :desc)
    .limit(quantity)
  end
end
