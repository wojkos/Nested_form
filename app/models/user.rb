class User < ApplicationRecord
  has_one :company
  has_one :address, as: :addressable
  accepts_nested_attributes_for :company, :address
end
