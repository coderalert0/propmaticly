class Building < ApplicationRecord
  belongs_to :portfolio
  has_many :complaints, dependent: :destroy
end