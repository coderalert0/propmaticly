class Building < ApplicationRecord
  has_many :complaints, dependent: :destroy
end