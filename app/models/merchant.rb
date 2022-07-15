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
end
