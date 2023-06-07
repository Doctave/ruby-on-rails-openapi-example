class Order < ApplicationRecord

  validates :kind, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :customer, presence: true
end
