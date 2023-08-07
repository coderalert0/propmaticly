class Portfolio < ApplicationRecord
  has_many :buildings, dependent: :destroy
end