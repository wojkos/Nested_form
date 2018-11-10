class User < ApplicationRecord
  has_one :company
  has_one :address
  accepts_nested_attributes_for :company, :address
end
