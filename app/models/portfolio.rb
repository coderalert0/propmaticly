# frozen_string_literal: true

class Portfolio < ApplicationRecord
  has_many :buildings, dependent: :destroy
end
