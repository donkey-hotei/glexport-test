class Company < ApplicationRecord
  has_many :shipments
  has_many :products

  validates :name, presence: true
end
